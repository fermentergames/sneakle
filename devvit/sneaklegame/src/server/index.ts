import { Hono } from "hono";
import { serve } from "@hono/node-server";
import {
  createServer,
  context,
  getServerPort,
  reddit,
  redis
} from "@devvit/web/server";
//import { RunAs } from '@devvit/public-api';
import { createPost } from "./core/post";
// import { navigateTo } from '@devvit/web/client';
import { registerDebugRoutes } from "./debugApi";
import { Logger } from './utils/Logger';
import { buildProfileResponse, getUserProfile, saveUserProfile } from "./utils/profileHelpers";

//import { getCurrentDailyCount, getCurrentLevelCount } from "../actions/createGamePost";
import { getPrevNextDailyPost } from "./utils/puzzleQueueHelpers";


/* ========== Start Focus - Import action files ========== */
//import { menuActionOld } from './actions/1_menuAction';
//import { formAction } from './actions/2_formAction';
//import { scheduledAction } from './actions/3_scheduledAction';
//import { initGameAction } from './actions/4_initGameAction';
//
//import { scheduledPuzzlePostActionOld } from './actions/OLD_postPuzzle';

//scheduled stuff
import { scheduledPuzzlePostAction } from './actions/autoPostPuzzleFromQueue';
import { resyncUserProfilesJob } from './actions/resyncUserProfilesJob';
import { resyncCreatedKarmaJob } from './actions/resyncCreatedKarmaJob';
//

//import { registerPuzzleMenuActions } from "./actions/menuActions";
//import { addPuzzleForm } from "./actions/addPuzzleToDailyQueue";

import { menuActions } from "./actions/menuActions";
//import { addPuzzleForm } from "./actions/formHandler"; // your form POST/GET handlers
//import { puzzleMenuActions } from './actions/puzzleMenuActions';

import { createGamePostFromPuzzle } from "./actions/createGamePost";



/* ========== End Focus - Import action files ========== */



const app = new Hono();
const router = app;

/* ========== Start Focus - Register game actions ========== */
//menuActionOld(router);
//formAction(router);
//scheduledAction(router);
//initGameAction(router);
//
//scheduledPuzzlePostActionOld(router);
scheduledPuzzlePostAction(router);
resyncUserProfilesJob(router);
resyncCreatedKarmaJob(router);

//registerPuzzleMenuActions(router);
//addPuzzleForm(router);

// ==== Menu Items + Form Handlers ====
menuActions(router);
registerDebugRoutes(router);

// ==== Form Handlers ====
//addPuzzleForm(router);


/* ========== End Focus - Register game actions ========== */


//

//init is called by main.ts in client
router.get("/api/init", async (c) => {

  console.log("app/init happening in index.ts");

  const { postId } = context;

  if (!postId) {
    console.error("API Init Error: postId not found in devvit context");
    return c.json({
      status: "error",
      message: "postId is required but missing from context",
    }, 400);
  }

  try {
    const username = await reddit.getCurrentUsername();

    return c.json({
      type: "init",
      postId: postId,
      username: username ?? "anonymous",
    });
  } catch (error) {
    console.error(`API Init Error for post ${postId}:`, error);
    let errorMessage = "Unknown error during initialization";
    if (error instanceof Error) {
      errorMessage = `Initialization failed: ${error.message}`;
    }
    return c.json({ status: "error", message: errorMessage }, 400);
  }
});

// Add your game-specific API endpoints here
// Examples:
// router.post("/api/save-score", async (c) => { ... });
// router.get("/api/leaderboard", async (c) => { ... });
// router.post("/api/game-event", async (c) => { ... });

// ##########################################################################
// # DEMO SAMPLE: State + Score + Leaderboard using Redis
// ##########################################################################

type StoredState = {
  username: string;
  data?: Record<string, unknown>;
  updatedAt: number;
};


function stateKey(postId: string, username: string) {
  return `state:${postId}:${username}`;
}
function leaderboardKey(postId: string) {
  return `lb:${postId}`;
}
function leaderboardTimeKey(postId: string) {
  return `lb:time:${postId}`;
}
async function getUsername(): Promise<string> {
  const u = await reddit.getCurrentUsername();
  return u ?? "anonymous";
}

function getRequestedPostId(c: any): string | undefined {
  const queryPostId = c.req.query("postId");
  return typeof queryPostId === "string" && queryPostId.trim() !== ""
    ? queryPostId
    : undefined;
}

async function syncPuzzleCacheFromPostData(postId: string, postData: Record<string, unknown> | null | undefined): Promise<void> {
  if (!postData) return;

  const levelID = String(postData.levelID ?? await redis.get(`post:${postId}:levelID`) ?? "");
  if (!levelID) return;

  await redis.hSet(`puzzle:${levelID}`, {
    postId,
    levelName: String(postData.levelName ?? ""),
    levelTag: String(postData.levelTag ?? ""),
    levelID,
    levelDate: String(postData.levelDate ?? ""),
    levelCreator: String(postData.levelCreator ?? ""),
    gameData: String(postData.gameData ?? ""),
    dailyID: String(postData.dailyID ?? ""),
    totalPlayers: String(postData.totalPlayers ?? "0"),
    totalPlayersCompleted: String(postData.totalPlayersCompleted ?? "0"),
    totalGuesses: String(postData.totalGuesses ?? "0"),
    totalTime: String(postData.totalTime ?? "0"),
    totalScore: String(postData.totalScore ?? "0"),
    nonStandard: String(postData.nonStandard ?? "0"),
  });
}


// STATE stuff

async function updateState({
  postId,
  username,
  data,
}: {
  postId: string;
  username: string;
  data?: Record<string, any>;
}): Promise<StoredState> {

  const key = stateKey(postId, username);

  const prevRaw = await redis.get(key);
  const prev = (prevRaw ? JSON.parse(prevRaw) : {}) as Partial<StoredState>;

  // build the new state; only include optional fields if they exist 
  const next: StoredState = {
    ...prev,
    username,
    data: {
      ...(prev.data ?? {}),
      ...(data ?? {}),
    },
    updatedAt: Date.now(),
  };

  await redis.set(key, JSON.stringify(next));

  return next;
}


// GET /api/state?postId=t3_abc123 -> fetch current user's state for this postId
router.get("/api/state", async (c) => {
  try {
    // const { postId } = context;
    // if (!postId) return c.json({ error: "Missing postId in context" }, 400);

    //console.log("get /api/state happening");
    //console.log("query.postId:", c.req.query("postId"));

    // 1. Explicit override always wins
    const queryPostId = getRequestedPostId(c);

    //console.log("c.req.query("postId") = "+c.req.query("postId")+" (empty means use current context postId)");

    // 2. Fallback to context if it exists
    const postId = queryPostId ?? context.postId;

    
    //console.log("postId = "+postId);


    // 3. If still missing, this request is NOT in post context
    if (!postId || postId == undefined) {
      return c.json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      }, 400);
    }

    //console.log("GET /api/state for postId "+postId);

    const username = await getUsername();
    const key = stateKey(postId, username);
    const stateRaw = await redis.get(key);
    //if (!stateJson) return c.json({ error: "No state found" }, 404);

    //console.log("stateJson = "+JSON.stringify(stateJson));

    //res.json(JSON.parse(stateJson) as StoredState);

    let stateJson: any = {};
    if (stateRaw) {
      try {
        stateJson = JSON.parse(stateRaw);
      } catch (e) {
        console.error("Failed to parse state JSON:", e);
      }
    }

    console.log(`Get /api/state happening for username: ${username} on postId: ${postId}`);

    console.log("stateJson =", JSON.stringify(stateJson));

    const response = {
      username: username ?? "anonymous",
      score_guesses: stateJson?.data?.score_guesses ?? "0",
      score_hints: stateJson?.data?.score_hints ?? "0",
      score_time: stateJson?.data?.score_time ?? "0",
      score_combined: stateJson?.data?.score_combined ?? "0",
      level_status: stateJson?.data?.level_status ?? "0",
      level_commented: stateJson?.data?.level_commented ?? "0",
    };

    //console.log("GET /api/state complete");

    return c.json(response);


  } catch (err) {
    console.error("GET /api/state error:", err);
    return c.json({ error: "Failed to fetch state" }, 500);
  }
});

// POST /api/state?postId=t3_abc123 -> upsert current user's state for this postId
router.post("/api/state", async (c) => {
  try {

    // 1. Prefer explicit postId from request
    const requestedPostId = getRequestedPostId(c);

    // 2. Fallback to context postId
    const postId = requestedPostId ?? context.postId;

    if (!postId) {
      return c.json({ error: "Missing postId" }, 400);
    }

    const username = await getUsername();
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    console.log("POST /api/state happening for user: "+username+" at postId: "+postId);

    const { data } = await c.req.json<any>();

    console.log("Posting State data:\n" + JSON.stringify(data, null, 2));

    if (data !== undefined && (typeof data !== "object" || data === null)) {
      return c.json({ error: "data must be an object" }, 400);
    }
    
    const next = await updateState({ postId, username, data });

    return c.json(next);

    //

  } catch (err) {
    console.error("POST /api/state error:", err);
    return c.json({ error: "Failed to save state" }, 500);
  }
});


/////end of state stuff






// GET /api/profile -> fetch current user's state for profile 
router.get("/api/profile", async (c) => {
  try {
    console.log('GET /api/profile happening', { query: c.req.query() });

    const username = await getUsername();
    //if (!username) return c.json({ error: "Missing username" }, 400);
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    //console.log(key);

    const profile = await getUserProfile(username);

    console.log(JSON.stringify(profile?.profileData ?? {}));

    console.log(`GET /api/profile worked for user: ${username}`, { query: c.req.query() });

    return c.json(buildProfileResponse(username, profile));

  } catch (err) {
    console.error("GET /api/profile error:", err);
    return c.json({ error: "Failed to fetch profile for user" }, 500);
  }
});


// POST /api/profile -> upsert current user's state for profile
router.post("/api/profile", async (c) => {
  try {

    console.log('POST /api/profile happening', { query: c.req.query() });

    const username = await getUsername();
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    const actorUsername = username;

    const { profileData } = await c.req.json<any>();

    if (profileData !== undefined && (typeof profileData !== "object" || profileData === null)) {
      return c.json({ error: "profileData must be an object" }, 400);
    }
    
    const next = await saveUserProfile({
      username,
      profileData: profileData ?? {},
      updatedBy: actorUsername,
    });

    console.log(JSON.stringify(next));

    console.log('POST /api/profile complete');

    return c.json(next);
  } catch (err) {
    console.error("POST /api/profile error:", err);
    return c.json({ error: "Failed to save profile for user" }, 500);
  }
});

router.get("/api/leaderboard-alltime", async (c) => {
  try {
    type LeaderboardCategory = "daily" | "community" | "unlimited" | "created";
    type LeaderboardMetric = "total" | "avg" | "karma" | "players";
    const rawCategory = String(c.req.query("category") ?? "daily").toLowerCase();
    const category: LeaderboardCategory =
      rawCategory === "community" || rawCategory === "unlimited" || rawCategory === "created"
        ? rawCategory
        : "daily";
    const rawMetric = String(c.req.query("metric") ?? "total").toLowerCase();
    let requestedMetric: LeaderboardMetric = "total";
    if (rawMetric === "avg") requestedMetric = "avg";
    else if (rawMetric === "karma") requestedMetric = "karma";
    else if (rawMetric === "players") requestedMetric = "players";
    const metric: LeaderboardMetric =
      category === "created"
        ? (requestedMetric === "karma" || requestedMetric === "players" ? requestedMetric : "total")
        : (requestedMetric === "avg" ? "avg" : "total");

    const fieldByCategory: Record<LeaderboardCategory, Record<LeaderboardMetric, string>> = {
      daily:     { total: "stat_d_total_score", avg: "stat_d_avg_score",  karma: "stat_d_total_score",  players: "stat_d_total_started" },
      community: { total: "stat_c_total_score", avg: "stat_c_avg_score",  karma: "stat_c_total_score",  players: "stat_c_total_started" },
      unlimited: { total: "stat_u_total_score", avg: "stat_u_avg_score",  karma: "stat_u_total_score",  players: "stat_u_total_started" },
      created:   { total: "created_total",      avg: "created_total",     karma: "created_karma",       players: "created_players" },
    };
    const scoreField = fieldByCategory[category][metric];
    const playedFieldByCategory: Record<LeaderboardCategory, string | null> = {
      daily: "stat_d_total_started",
      community: "stat_c_total_started",
      unlimited: "stat_u_total_started",
      created: null,
    };
    const playedField = playedFieldByCategory[category];

    const keyByCategoryMetric: Record<LeaderboardCategory, Record<LeaderboardMetric, string>> = {
      daily:     { total: "lb:alltime:daily:total",     avg: "lb:alltime:daily:avg",     karma: "lb:alltime:daily:total",     players: "lb:alltime:daily:total" },
      community: { total: "lb:alltime:community:total", avg: "lb:alltime:community:avg", karma: "lb:alltime:community:total", players: "lb:alltime:community:total" },
      unlimited: { total: "lb:alltime:unlimited:total", avg: "lb:alltime:unlimited:avg", karma: "lb:alltime:unlimited:total", players: "lb:alltime:unlimited:total" },
      created:   { total: "lb:alltime:created:total",   avg: "lb:alltime:created:total", karma: "lb:alltime:created:karma",   players: "lb:alltime:created:players" },
    };
    const leaderboardKey = keyByCategoryMetric[category][metric];

    const labelByMetric: Record<LeaderboardMetric, string> = {
      total:   category === "created" ? "Total Made" : "Total Score",
      avg:     "Average Score",
      karma:   "Total Karma",
      players: "Total Players",
    };

    const scoreLabel = labelByMetric[metric];

    const limitParam = Number(c.req.query("limit") ?? "10");
    const limit = Number.isFinite(limitParam) ? Math.max(1, Math.min(limitParam, 200)) : 50;
    const pageParam = Number(c.req.query("page") ?? "1");
    const requestedPage = Number.isFinite(pageParam) ? Math.max(1, pageParam) : 1;
    const includeZero = String(c.req.query("includeZero") ?? "0") === "1";

    const viewer = await getUsername();
    const subredditName = context.subredditName ?? "Sneakle";

    const getCreatedPostIds = (rawIds: unknown): string[] => {
      if (Array.isArray(rawIds)) {
        return rawIds.map((id) => String(id)).filter((id) => id.length > 0);
      }
      if (typeof rawIds === "string") {
        if (!rawIds || rawIds === "-1") return [];
        return rawIds.split(",").map((id) => id.trim()).filter(Boolean);
      }
      return [];
    };

    const getPostPlayersTotal = async (postId: string): Promise<number> => {
      try {
        const levelID = await redis.get(`post:${postId}:levelID`);
        if (levelID) {
          const puzzleData = await redis.hGetAll(`puzzle:${levelID}`);
          if (puzzleData && Object.keys(puzzleData).length > 0 && puzzleData.totalPlayers !== undefined) {
            return Number(puzzleData.totalPlayers ?? "0") || 0;
          }
        }
      } catch {
        // fall through to leaderboard cardinality fallback
      }

      try {
        return Number((await redis.zCard(`lb:${postId}`)) ?? 0) || 0;
      } catch {
        return 0;
      }
    };

    const hydrateCreatedPlayersForUser = async (username: string): Promise<number> => {
      const raw = await redis.get(`profile:${username}`);
      if (!raw) return 0;

      try {
        const parsed = JSON.parse(raw) as { profileData?: Record<string, string> };
        const profileData = parsed.profileData ?? {};
        const postIds = getCreatedPostIds(profileData.created_ids);
        if (postIds.length === 0) {
          await redis.zAdd("lb:alltime:created:players", { score: 0, member: username });
          return 0;
        }

        const counts = await Promise.all(postIds.map((pid) => getPostPlayersTotal(pid)));
        const createdPlayers = counts.reduce((sum, n) => sum + n, 0);

        profileData.created_players = String(createdPlayers);
        await redis.set(`profile:${username}`, JSON.stringify({
          ...parsed,
          profileData,
          username,
          updatedBy: "system",
          updatedAt: new Date().toISOString(),
        }));
        await redis.zAdd("lb:alltime:created:players", { score: createdPlayers, member: username });

        return createdPlayers;
      } catch {
        return 0;
      }
    };

    let allAsc = await redis.zRange(leaderboardKey, 0, -1);

    // Lazy hydrate created players entries if this metric is requested and members are missing.
    if (category === "created" && metric === "players") {
      const creatorsAsc = await redis.zRange("lb:alltime:created:total", 0, -1);
      for (const creator of creatorsAsc) {
        const username = creator.member;
        if (!username) continue;
        const createdTotal = Number(creator.score ?? 0) || 0;
        if (createdTotal <= 0) continue;
        const existing = await redis.zScore("lb:alltime:created:players", username);
        const existingPlayers = Number(existing ?? 0) || 0;
        const needsHydration = existing === undefined || existing === null || existingPlayers <= 0;
        if (!needsHydration) continue;
        await hydrateCreatedPlayersForUser(username);
      }
      allAsc = await redis.zRange(leaderboardKey, 0, -1);
    }

    // Bootstrap zsets for existing users if this leaderboard has not been populated yet.
    if (allAsc.length === 0) {
      const usernameSet = new Set<string>();
      const allPosts = await redis.zRange("levelList", 0, -1);

      for (const post of allPosts) {
        const lbRows = await redis.zRange(`lb:${post.member}`, 0, -1);
        for (const row of lbRows) {
          if (row.member) usernameSet.add(row.member);
        }
      }

      if (viewer && viewer !== "anonymous") {
        usernameSet.add(viewer);
      }

      for (const username of usernameSet) {
        const raw = await redis.get(`profile:${username}`);
        if (!raw) continue;
        const parsed = JSON.parse(raw) as { profileData?: Record<string, string> };
        const p = parsed.profileData ?? {};

        const dailyTotal = Number(p.stat_d_total_score ?? "0") || 0;
        const dailyFinished = Number(p.stat_d_total_finished ?? "0") || 0;
        const dailyAvg = dailyFinished > 0 ? dailyTotal / dailyFinished : 0;

        const communityTotal = Number(p.stat_c_total_score ?? "0") || 0;
        const communityFinished = Number(p.stat_c_total_finished ?? "0") || 0;
        const communityAvg = communityFinished > 0 ? communityTotal / communityFinished : 0;

        const unlimitedTotal = Number(p.stat_u_total_score ?? "0") || 0;
        const unlimitedFinished = Number(p.stat_u_total_finished ?? "0") || 0;
        const unlimitedAvg = unlimitedFinished > 0 ? unlimitedTotal / unlimitedFinished : 0;

        const createdTotal = Number(p.created_total ?? "0") || 0;
        const createdKarma = Number(p.created_karma ?? "0") || 0;

        // Compute created_players by summing per-puzzle player counts when not cached
        let createdPlayers = Number(p.created_players ?? "0") || 0;
        if (createdPlayers === 0 && createdTotal > 0) {
          const postIds = getCreatedPostIds(p.created_ids);
          const counts = await Promise.all(postIds.map((pid) => getPostPlayersTotal(pid)));
          createdPlayers = counts.reduce((sum, n) => sum + n, 0);
        }

        await redis.zAdd("lb:alltime:daily:total", { score: dailyTotal, member: username });
        if (dailyFinished >= 5) {
          await redis.zAdd("lb:alltime:daily:avg", { score: dailyAvg, member: username });
        }
        await redis.zAdd("lb:alltime:community:total", { score: communityTotal, member: username });
        if (communityFinished >= 5) {
          await redis.zAdd("lb:alltime:community:avg", { score: communityAvg, member: username });
        }
        await redis.zAdd("lb:alltime:unlimited:total", { score: unlimitedTotal, member: username });
        if (unlimitedFinished >= 5) {
          await redis.zAdd("lb:alltime:unlimited:avg", { score: unlimitedAvg, member: username });
        }
        await redis.zAdd("lb:alltime:created:total",   { score: createdTotal,   member: username });
        await redis.zAdd("lb:alltime:created:karma",   { score: createdKarma,   member: username });
        await redis.zAdd("lb:alltime:created:players", { score: createdPlayers, member: username });
      }

      allAsc = await redis.zRange(leaderboardKey, 0, -1);
    }

    const ranked = allAsc
      .toReversed()
      .map((e) => ({ username: e.member, score: Number(e.score ?? 0) || 0 }))
      .filter((s) => includeZero ? true : s.score > 0);

    const totalPlayers = ranked.length;
    const totalPages = Math.max(1, Math.ceil(totalPlayers / limit));
    const page = Math.min(requestedPage, totalPages);
    const start = (page - 1) * limit;

    const pageEntries = ranked.slice(start, start + limit);
    const usernamesToLoad = new Set(pageEntries.map((entry) => entry.username));
    if (viewer && viewer !== "anonymous") {
      usernamesToLoad.add(viewer);
    }

    const playedCountByUsername = new Map<string, number>();
    if (playedField) {
      const playedProfiles = await Promise.all([...usernamesToLoad].map(async (username) => {
        try {
          const raw = await redis.get(`profile:${username}`);
          const parsed = raw ? JSON.parse(raw) as { profileData?: Record<string, string> } : null;
          const playedCount = Number(parsed?.profileData?.[playedField] ?? "0") || 0;
          return { username, playedCount };
        } catch (_err) {
          return { username, playedCount: 0 };
        }
      }));

      for (const entry of playedProfiles) {
        playedCountByUsername.set(entry.username, entry.playedCount);
      }
    }

    const entries = pageEntries.map((entry, idx) => ({
      rank: start + idx + 1,
      username: entry.username,
      score: entry.score,
      playedCount: playedField ? (playedCountByUsername.get(entry.username) ?? 0) : undefined,
      searchUrl: `https://www.reddit.com/r/${encodeURIComponent(subredditName)}/search/?q=author%3A${encodeURIComponent(entry.username)}`,
    }));

    const selfIndex = ranked.findIndex((r) => r.username === viewer);
    const selfEntry = selfIndex >= 0 ? ranked[selfIndex] : undefined;
    const self = selfEntry
      ? {
          rank: selfIndex + 1,
          username: selfEntry.username,
          score: selfEntry.score,
          playedCount: playedField ? (playedCountByUsername.get(selfEntry.username) ?? 0) : undefined,
          searchUrl: `https://www.reddit.com/r/${encodeURIComponent(subredditName)}/search/?q=author%3A${encodeURIComponent(selfEntry.username)}`,
        }
      : null;

    return c.json({
      category,
      metric,
      scoreField,
      scoreLabel,
      includeZero,
      subredditName,
      totalPlayers,
      page,
      totalPages,
      pageSize: limit,
      entries,
      self,
    });
  } catch (err) {
    console.error("GET /api/leaderboard-alltime error:", err);
    return c.json({ error: "Failed to fetch all-time leaderboard" }, 500);
  }
});

//end of profile


// GET /api/load-post-data -> load postData for this post
router.get('/api/load-post-data', async (c) => {

    console.log("app/load-post-data happening");

    // Create a logger
    const logger = await Logger.Create('API - Load Post Data');
    logger.traceStart('API Action');

    try {

      logger.info("Load Post Data happening");

      /* ========== Start Focus - Fetch from redis + return result ========== */

      // 1. Explicit override always wins
      const queryPostId = getRequestedPostId(c);

      logger.info(`c.req.query("postId") = ${c.req.query("postId")} (empty means use current context postId)`);

      // 2. Fallback to context if it exists
      const postId = queryPostId ?? context.postId;

      logger.info("postId = "+postId);


      // 3. If still missing, this request is NOT in post context
      if (!postId || postId == undefined) {
        return c.json({
          error:
            "postId missing: this endpoint was called outside of post context and no postId was provided",
        }, 400);
      }

      // 4. Fetch the post explicitly
      const post = await reddit.getPostById(postId as `t3_${string}`);
      const postData = await post.getPostData();

      // Confirm post data and level name exists
      //const { postData } = context;
      if (!postData || !postData.levelName || typeof postData.levelName !== 'string') {
        logger.error('API Load Post Data Error: postData.levelName not found in devvit context');
        return c.json({
          status: 'error',
          message: 'postData.levelName is required but missing from context',
        }, 400);
      }

      // Fail if level data is missing
      if (!postData.gameData) {
        logger.error('API Load Post Data Error: gameData not found in redis');
        return c.json({
          status: 'error',
          message: 'gameData is required but missing from redis',
        }, 400);
      }

      logger.info("postData = "+JSON.stringify(postData));

      // Otherwise, return data back to post!
      return c.json({
        type: "init",

        levelName: postData?.levelName ?? "Sneakle Level",
        gameData: postData?.gameData ?? "",
        levelTag: postData?.levelTag ?? "No Tag",
        levelID: postData?.levelID ?? "-1",
        dailyID: postData?.dailyID ?? "-1",
        levelCreator: postData?.levelCreator ?? "SneakleBot",
        levelDate: postData?.levelDate ?? "0",
        totalPlayers: postData?.totalPlayers ?? "0",
        totalPlayersCompleted: postData?.totalPlayersCompleted ?? "0",
        totalGuesses: postData?.totalGuesses ?? "0",
        totalTime: postData?.totalTime ?? "0",
        totalScore: postData?.totalScore ?? "0",
        nonStandard: postData?.nonStandard ?? "0",
        postId: postId ?? "-1",
      });

      /* ========== End Focus - Fetch from redis + return result ========== */

    } catch (error) {
      logger.error('Error in Load Post Data action: ', error);
      return c.json({
        status: 'error',
        message: 'Load Post Data action failed'
      }, 400);
    } finally {
      logger.traceEnd();
    }
});


// POST /api/update-post-data -> submit/update postData for this post
router.post("/api/update-post-data", async (c) => {

  // 1. Explicit override always wins
  const queryPostId = getRequestedPostId(c);

  // 2. Fallback to context if it exists
  const postId = queryPostId ?? context.postId;

  // 3. If still missing, this request is NOT in post context
  if (!postId) {
    return c.json({
      error:
        "postId missing: this endpoint was called outside of post context and no postId was provided",
    }, 400);
  }

  try {
    console.log("POST /api/update-post-data happening for postId "+postId, { query: c.req.query() });

    const username = await getUsername();
    //if (!username) return c.json({ error: "Missing username" }, 400);
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    const { data } = await c.req.json<any>();

    if (data !== undefined && (typeof data !== "object" || data === null)) {
      return c.json({ error: "data must be an object" }, 400);
    }

    console.log('POST /api/update-post-data step 2');

    console.log(JSON.stringify(data));


    const post = await reddit.getPostById(postId as `t3_${string}`);

    // Get existing post data to merge with updates
    const currentData = (await post.getPostData()) ?? {};

    const merged = {
      ...currentData,
      ...(data ?? {}),
      lastUpdatedBy: username || 'anonymous',
      lastUpdatedAt: new Date().toISOString(),
    };

    await post.setPostData(merged);
    await syncPuzzleCacheFromPostData(postId, merged as Record<string, unknown>);

    return c.json({
      success: true,
      message: 'Post data updated successfully'
    });
  } catch (err) {
    console.error("POST /api/update-post-data error:", err);
    return c.json({ error: "Failed to update-post-data" }, 500);
  }
});

// POST /api/score -> submit/update best score for this post
router.post("/api/score", async (c) => {
  try {


    // 1. Explicit override always wins
    const queryPostId = getRequestedPostId(c);

    // 2. Fallback to context if it exists
    const postId = queryPostId ?? context.postId;

    // 3. If still missing, this request is NOT in post context
    if (!postId) {
      return c.json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      }, 400);
    }

    const username = await getUsername();
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    const payload = await c.req.json<any>();
    const { score } = payload;
    if (typeof score !== "number" || !Number.isFinite(score)) {
      return c.json({ error: "score must be a finite number" }, 400);
    }

    // simple clamp, avoids abuse with huge numbers
    const sanitized = Math.max(0, Math.min(score, 1_000_000_000));
    const lbKey = leaderboardKey(postId);

    // read old score (if any) and keep the max
    const existing = await redis.zScore(lbKey, username);
    const best = existing !== undefined && existing !== null
      ? Math.max(Number(existing), sanitized)
      : sanitized;

    // zAdd here updates the sorted set; score used for ranking, member is the username
    await redis.zAdd(lbKey, { score: best, member: username });

    // Track best (lowest) time in a dedicated zset for time-based leaderboard views.
    let submittedTime = Number(payload?.score_time);
    if (!Number.isFinite(submittedTime) || submittedTime <= 0) {
      try {
        const stateRaw = await redis.get(stateKey(postId, username));
        if (stateRaw) {
          const stateJson = JSON.parse(stateRaw) as { data?: Record<string, unknown> };
          submittedTime = Number(stateJson?.data?.score_time ?? 0);
        }
      } catch {
        submittedTime = 0;
      }
    }

    if (Number.isFinite(submittedTime) && submittedTime > 0) {
      const sanitizedTime = Math.max(0, Math.min(submittedTime, 1_000_000_000));
      const timeKey = leaderboardTimeKey(postId);
      const existingTime = await redis.zScore(timeKey, username);
      const bestTime = existingTime !== undefined && existingTime !== null
        ? Math.min(Number(existingTime) || sanitizedTime, sanitizedTime)
        : sanitizedTime;
      await redis.zAdd(timeKey, { score: bestTime, member: username });
    }

    console.log('score submitted in endpoint');

    // also mirror this best score into the per-user state
    // const sKey = stateKey(postId, username);
    // const prevRaw = await redis.get(sKey);
    // const prev = (prevRaw ? JSON.parse(prevRaw) : {}) as Partial<StoredState>;

    // const next: StoredState = {
    //   username,
    //   updatedAt: Date.now(),
    //   ...(prev.data  !== undefined ? { data: prev.data } : {}),
    //   bestScore: best,
    // };

    // await redis.set(sKey, JSON.stringify(next));

    const updatedAt = Date.now();

    return c.json({ username, score: best, updatedAt: updatedAt });
  } catch (err) {
    console.error("POST /api/score error:", err);
    return c.json({ error: "Failed to submit score" }, 500);
  }
});






// POST /api/leaderboard-comment
router.post("/api/leaderboard-comment", async (c) => {
  try {

    console.log("api/leaderboard-comment happening");

    // const queryPostId =
    //   typeof c.req.query("postId") === "string" && c.req.query("postId").trim() !== ""
    //     ? c.req.query("postId")
    //     : undefined;

    //   console.log("comment-score happening")

    // const postId = queryPostId ?? context.postId;
    // if (!postId) return c.json({ error: "postId missing" }, 400);


    const postId = getRequestedPostId(c) ?? null;

    if (!postId) {
      return c.json({ error: "Valid postId required" }, 400);
    }

    console.log("Incoming postId:", c.req.query("postId"));
    console.log("Using postId:", postId);

    const lbKey = leaderboardKey(postId);

    // Get total leaderboard size
    const total = await redis.zCard(lbKey); // number of members
    if (total === 0) {
      console.log("Leaderboard empty, nothing to update");
      return c.json({ message: "Leaderboard empty" });
    }

    const limitParam = 10; //Number(c.req.query("limit") ?? 10);
    const limitTop = Number.isFinite(limitParam)
      ? Math.max(1, Math.min(limitParam, 100))
      : 10;

    // Get top `limitTop` (ascending slice from end)
    const topStart = Math.max(0, total - limitTop);
    const topAsc = await redis.zRange(lbKey, topStart, total - 1);

    // Reverse to get descending scores
    const top10Entries = topAsc.toReversed().map((e, i) => {
      const ascIndex = topStart + (topAsc.length - 1 - i);
      return {
        rank: total - ascIndex,
        username: e.member,
        score: Number(e.score ?? 0),
      };
    });


    // get the post + postData
    const post = await reddit.getPostById(postId as `t3_${string}`);
    const postData = await post.getPostData();

    if (!postData) {
      return c.json({ error: "Missing post data" }, 404);
    }

    const levelName = postData.levelName;

    const totalPlayers = Number(postData.totalPlayers) || 0;
    const totalPlayersDisplay = totalPlayers.toLocaleString();

    const totalScore = Number(postData.totalScore) || 0;

    const totalCompleted = Number(postData.totalPlayersCompleted) || 0;

    const avgScore = totalCompleted > 0 ? (totalScore / totalCompleted).toFixed(0) : "0";

    const completionRate =
      totalPlayers > 0
        ? ((totalCompleted / totalPlayers) * 100).toFixed(0)
        : "0";

    //console.log("leaderboard-comment happening 3")

    const MARKER = "Leaderboard (Top 10)"; //used in comment lookup below
    // const leaderboardMarkdown =
    //   `🏆 **Leaderboard (Top 10)**\n\n` +
    //   top10Entries
    //     .map((entry) => `**${entry.rank}. ${entry.username}** - ${entry.score} pts`)
    //     .join("\n\n") +
    //   `\n\n_Last updated: ${new Date().toLocaleString()}_`; 

    const leaderboardMarkdown = `
  🏆 **Leaderboard (Top 10) - ${levelName}**

| Rank | Sneakler | Score |
|-----:|----------|-------|
${top10Entries
.map((entry) => {
  let rankDisplay = entry.rank.toString();
  if (entry.rank === 1) rankDisplay = "🥇 1";
  else if (entry.rank === 2) rankDisplay = "🥈 2";
  else if (entry.rank === 3) rankDisplay = "🥉 3";
  return `| ${rankDisplay} | ${entry.username} | ${entry.score} |`;
})
.join("\n")}
\n\n
--- 
\n\n
👥 **Total Players:** ${totalPlayersDisplay}  
📊 **Average Score:** ${avgScore}  
✅ **Completion Rate:** ${completionRate}%  
\n\n
_Finish this Sneakle puzzle to get ranked!_
_(Last updated: ${new Date().toLocaleString()})_`;

    //   console.log(leaderboardMarkdown)

    

    //const leaderboardMarkdown = `Test Comment edited again!\nnewline?\n${MARKER}`

    try {
      const comments = await reddit.getComments({ postId: postId as `t3_${string}` }).all();

      //console.log(JSON.stringify(comments))

      //c.author?.name === "sneaklebot" && 

      const lbComment = comments.find(
        (c) => c.body?.includes(MARKER)
      );

      if (lbComment) {
        await lbComment.edit({ text: leaderboardMarkdown });
      } else {
        const comment = await reddit.submitComment({
          id: postId as `t3_${string}`,
          text: leaderboardMarkdown,
        });
        await comment.distinguish(true);
      }
    } catch (redditErr) {
      console.error("Error updating leaderboard comment inner:", redditErr);
      return c.json({ error: "Failed to update leaderboard comment inner" }, 500);
    }

    return c.json({ message: "Leaderboard comment updated"});
  } catch (err) {
    console.error("Leaderboard comment endpoint error:", err);
    return c.json({ error: "Failed to update leaderboard comment" }, 500);
  }
});





// POST /api/comment-score
router.post("/api/comment-score", async (c) => {
  try {

    console.log("api/comment-score happening");

    // const queryPostId =
    //   typeof c.req.query("postId") === "string" && c.req.query("postId").trim() !== ""
    //     ? c.req.query("postId")
    //     : undefined;

    //   console.log("comment-score happening")

    // const postId = queryPostId ?? context.postId;
    // if (!postId) return c.json({ error: "postId missing" }, 400);


    const postId = getRequestedPostId(c) ?? null;

    if (!postId) {
      return c.json({ error: "Valid postId required" }, 400);
    }

    console.log("Incoming postId:", c.req.query("postId"));
    console.log("Using postId:", postId);

    const { score } = await c.req.json<any>();
    if (score === undefined || score === null)
      return c.json({ error: "score missing" }, 400);

    const username = await getUsername();
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    const MARKER = "Leaderboard (Top 10)";

    try {
      const comments = await reddit.getComments({ postId: postId as `t3_${string}` }).all();

      const lbComment = comments.find((c) =>
        c.body?.includes(MARKER)
      );

      if (!lbComment) {
        return c.json({ error: "Leaderboard comment not found" }, 404);
      }

      const scoreComment = `🎯 **${username}** scored **${score}** points on this Sneakle!`;

      // Reply AS THE USER
      // await reddit.asUser().submitComment({
      //   id: lbComment.id,
      //   text: scoreComment,
      // });

      await reddit.submitComment({
       id: lbComment.id,
       text: scoreComment,
       runAs: 'USER',
      })

      return c.json({ message: "Score comment posted" });
    } catch (redditErr) {
      console.error("Error posting user score comment:", redditErr);
      return c.json({ error: "Failed to post user score comment" }, 500);
    }
  } catch (err) {
    console.error("comment-score endpoint error:", err);
    return c.json({ error: "Failed to comment-score" }, 500);
  }
});


/////


// GET /api/leaderboard?limit=10 -> top N + caller's rank 
router.get("/api/leaderboard", async (c) => {
  try {
    const queryPostId = getRequestedPostId(c);

    const postId = queryPostId ?? context.postId;

    if (!postId) {
      return c.json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      }, 400);
    }

    const username = await getUsername();
    type PerPostLeaderboardMetric = "score" | "time";
    const rawMetric = String(c.req.query("metric") ?? "score").toLowerCase();
    const metric: PerPostLeaderboardMetric = rawMetric === "time" ? "time" : "score";
    const lbKey = metric === "time" ? leaderboardTimeKey(postId) : leaderboardKey(postId);
    const descending = metric === "score";
    const scoreLabel = metric === "time" ? "Time" : "Score";

    const limitParam = Number(c.req.query("limit") ?? 10);
    const limitTop = Number.isFinite(limitParam) ? Math.max(1, Math.min(limitParam, 100)) : 10;
    const pageParam = Number(c.req.query("page") ?? 1);

    // 1. total players
    const total = Number((await redis.zCard(lbKey)) ?? 0);

    // // -. Fetch the post explicitly
    // const post = await reddit.getPostById(postId);
    // const postData = await post.getPostData();

    // const postDataTotal = postData.totalPlayers
    // if (total > postDataTotal) {
    //   // update postData.totalPlayers
    // }

    if (total === 0) {
      return c.json({
        metric,
        scoreLabel,
        top: [],
        aroundMe: [],
        me: null,
        totalPlayers: 0,
        page: 1,
        totalPages: 1,
        generatedAt: Date.now(),
      });
    }

    // 2. get leaderboard page
    const totalPages = Math.max(1, Math.ceil(total / limitTop));
    const page = Number.isFinite(pageParam) ? Math.max(1, Math.min(pageParam, totalPages)) : 1;
    let top: Array<{ rank: number; username: string; score: number }> = [];

    if (descending) {
      const startRank = (page - 1) * limitTop + 1;
      const endRank = Math.min(total, page * limitTop);
      const topStart = Math.max(0, total - endRank);
      const topStop = Math.max(0, total - startRank);
      const topAsc = await redis.zRange(lbKey, topStart, topStop);

      top = topAsc.toReversed().map((e, i) => {
        const ascIndex = topStart + (topAsc.length - 1 - i);
        return {
          rank: total - ascIndex,
          username: e.member,
          score: Number(e.score ?? 0),
        };
      });
    } else {
      const topStart = (page - 1) * limitTop;
      const topStop = Math.min(total - 1, page * limitTop - 1);
      const topAsc = await redis.zRange(lbKey, topStart, topStop);

      top = topAsc.map((e, i) => ({
        rank: topStart + i + 1,
        username: e.member,
        score: Number(e.score ?? 0),
      }));
    }



    const ascRank = await redis.zRank(lbKey, username);

    const aroundRadius = limitTop;
    const halfWindow = Math.floor(aroundRadius / 2);

    let aroundMe: any[] = [];
    let me = null;

    if (ascRank !== null && ascRank !== undefined) {

      let aroundStart = ascRank - halfWindow;
      let aroundStop  = ascRank + halfWindow;

      // Clamp lower bound
      if (aroundStart < 0) {
        aroundStop += -aroundStart;
        aroundStart = 0;
      }

      // Clamp upper bound
      if (aroundStop > total - 1) {
        const overshoot = aroundStop - (total - 1);
        aroundStart = Math.max(0, aroundStart - overshoot);
        aroundStop = total - 1;
      }

      const aroundAsc = await redis.zRange(lbKey, aroundStart, aroundStop);

      if (descending) {
        aroundMe = aroundAsc.toReversed().map((e, i) => {
          const ascIndex = aroundStart + (aroundAsc.length - 1 - i);

          const entry = {
            rank: total - ascIndex,
            username: e.member,
            score: Number(e.score ?? 0),
          };

          if (e.member === username) {
            me = entry;
          }

          return entry;
        });
      } else {
        aroundMe = aroundAsc.map((e, i) => {
          const ascIndex = aroundStart + i;
          const entry = {
            rank: ascIndex + 1,
            username: e.member,
            score: Number(e.score ?? 0),
          };

          if (e.member === username) {
            me = entry;
          }

          return entry;
        });
      }
    }

    const usernamesToLoad = new Set<string>();
    for (const entry of top) usernamesToLoad.add(entry.username);
    for (const entry of aroundMe) usernamesToLoad.add(entry.username);
    if (me?.username) usernamesToLoad.add(me.username);

    const guessesByUser = new Map<string, number>();
    await Promise.all([...usernamesToLoad].map(async (entryUsername) => {
      try {
        const stateRaw = await redis.get(stateKey(postId, entryUsername));
        if (!stateRaw) {
          guessesByUser.set(entryUsername, 0);
          return;
        }
        const stateJson = JSON.parse(stateRaw) as { data?: Record<string, unknown> };
        const guesses = Number(stateJson?.data?.score_guesses ?? 0);
        guessesByUser.set(entryUsername, Number.isFinite(guesses) ? Math.max(0, guesses) : 0);
      } catch {
        guessesByUser.set(entryUsername, 0);
      }
    }));

    const applyGuesses = <T extends { username: string }>(entry: T) => ({
      ...entry,
      guesses: guessesByUser.get(entry.username) ?? 0,
    });

    return c.json({
      metric,
      scoreLabel,
      top: top.map(applyGuesses),
      aroundMe: aroundMe.map(applyGuesses),
      me: me ? applyGuesses(me) : null,
      totalPlayers: total,
      page,
      totalPages,
      generatedAt: Date.now(),
    });
  } catch (err) {
    console.error("GET /api/leaderboard error:", err);
    return c.json({ error: "Failed to fetch leaderboard" }, 500);
  }
});



///////////////////////


// GET /api/get-surrounding-daily-ids -> load postData for this post
router.get('/api/get-surrounding-daily-ids', async (c) => {

    console.log("app/get-surrounding-daily-ids happening");

    // Create a logger
    const logger = await Logger.Create('API - Get Surrounding Daily IDs');
    logger.traceStart('API Action');

    try {

      /* ========== Start Focus - Fetch from redis + return result ========== */

      // 1. Explicit override always wins
      const queryPostId = getRequestedPostId(c);

      logger.info(`c.req.query("postId") = ${c.req.query("postId")} (empty means use current context postId)`);

      // 2. Fallback to context if it exists
      const postId = queryPostId ?? context.postId;

      // 3. If still missing, this request is NOT in post context
      if (!postId) {
        return c.json({
          error:
            "postId missing: this endpoint was called outside of post context and no postId was provided",
        }, 400);
      }

      const { prev, next } = await getPrevNextDailyPost(postId, logger);
      const today = postId;

      logger.info("daily_prev_postId = "+prev);
      logger.info("daily_next_postId = "+next);
      logger.info("daily_today_postId = "+today);

      // Otherwise, return data back to post!
      return c.json({
        daily_prev_postId: prev ?? "-9999",
        daily_next_postId: next ?? "-9999",
        daily_today_postId: today ?? "-9999",
      });

      /* ========== End Focus - Fetch from redis + return result ========== */

    } catch (error) {
      logger.error('Error in get-surrounding-daily-ids action: ', error);
      return c.json({
        status: 'error',
        message: 'Load Post Data action failed'
      }, 400);
    } finally {
      logger.traceEnd();
    }
});

//////////////////////////////////////////////////////////////////////////////


router.get("/api/list-levels", async (c) => {
  try {
    const parseArchivePuzzleSize = (gameDataRaw: string | undefined): number => {
      const gameData = String(gameDataRaw ?? "");
      const boardMatch = gameData.match(/(?:^|[?&])loadBoard=([^&]+)/);
      if (!boardMatch?.[1]) return 0;
      const letterCount = boardMatch[1].length;
      const size = Math.sqrt(letterCount);
      return Number.isInteger(size) ? size : 0;
    };

    const archiveDateValue = (rawValue: string | undefined): number => {
      const parsed = Date.parse(String(rawValue ?? ""));
      return Number.isFinite(parsed) ? parsed : 0;
    };

    const loadArchiveKarma = async (postId: string): Promise<number> => {
      try {
        const post = await reddit.getPostById(postId as `t3_${string}`);
        const karma = Number(post.score ?? 0);
        return Number.isFinite(karma) ? karma : 0;
      } catch {
        return 0;
      }
    };

    const cursorParam = Number(c.req.query("cursor") ?? 0);
    const pageParam = Number(c.req.query("page") ?? 1);
    const limitParam = Number(c.req.query("limit") ?? 10);
    const tag = String(c.req.query("tag") ?? "").trim();
    const sort = String(c.req.query("sort") ?? "date").trim().toLowerCase();
    const sizeFilter = String(c.req.query("size") ?? "").trim();
    const nonStandardFilter = String(c.req.query("nonStandard") ?? "any").trim().toLowerCase();
    const unplayedOnly = String(c.req.query("unplayedOnly") ?? "0") === "1";
    const authorFilter = String(c.req.query("author") ?? "").trim().toLowerCase();
    const titleFilter = String(c.req.query("title") ?? "").trim().toLowerCase();

    const cursor = Number.isFinite(cursorParam) ? Math.max(0, cursorParam) : 0;
    const page = Number.isFinite(pageParam) ? Math.max(1, pageParam) : 1;
    const limit = Number.isFinite(limitParam)
      ? Math.max(1, Math.min(limitParam, 50))
      : 10;
    const hasPageParam = c.req.query("page") !== undefined;
    const normalizedSort = ["date", "players", "avg", "karma"].includes(sort) ? sort : "date";
    const normalizedNonStandard = ["any", "standard", "nonstandard"].includes(nonStandardFilter)
      ? nonStandardFilter
      : "any";
    const normalizedSize = Number(sizeFilter);
    const sizeAtLeastEight = sizeFilter === "8plus";

    const total = await redis.zCard("levelList");

    if (total === 0) {
      return c.json({
        puzzles: [],
        nextCursor: cursor,
        hasMore: false,
        total: 0,
        totalFiltered: 0,
        page: hasPageParam ? page : 1,
        totalPages: 1,
      });
    }

    const postIdsAscending = await redis.zRange("levelList", 0, -1);
    // zRange returns { member, score } objects in Devvit Redis
    const postIds = [...postIdsAscending]
      .reverse()
      .map((item) => (typeof item === "string" ? item : item.member));

    const viewerUsername = await getUsername();
    const hasViewer = viewerUsername !== "anonymous";

    const archivePuzzles = (await Promise.all(postIds.map(async (postId) => {
      const levelID = await redis.get(`post:${postId}:levelID`);
      if (!levelID) return null;

      const data = await redis.hGetAll(`puzzle:${levelID}`);
      if (!data || Object.keys(data).length === 0) return null;

      let mergedData: Record<string, unknown> = { ...data };
      const missingCachedStats = data.totalPlayers === undefined
        || data.totalPlayersCompleted === undefined
        || data.totalScore === undefined;
      const cachedTotalPlayers = Number(data.totalPlayers ?? "0") || 0;
      //const cachedTotalPlayersCompleted = Number(data.totalPlayersCompleted ?? "0") || 0;
      //const cachedTotalScore = Number(data.totalScore ?? "0") || 0;

      let suspiciousZeroCachedStats = false;
      if (!missingCachedStats
        && cachedTotalPlayers === 0) {
        const leaderboardCount = Number((await redis.zCard(leaderboardKey(postId))) ?? 0);
        suspiciousZeroCachedStats = leaderboardCount > 0;
      }

      //self-heal if missing data from 'puzzle:..' cache
      if (missingCachedStats || suspiciousZeroCachedStats) {
        try {
          const livePostData = await reddit.getPostData(postId as `t3_${string}`);
          if (livePostData) {
            mergedData = { ...data, ...livePostData };
            await syncPuzzleCacheFromPostData(postId, livePostData as Record<string, unknown>);
          }
        } catch {
          mergedData = { ...data };
        }
      }

      const totalPlayers = Number(mergedData.totalPlayers ?? "0") || 0;
      const totalPlayersCompleted = Number(mergedData.totalPlayersCompleted ?? "0") || 0;
      const totalScore = Number(mergedData.totalScore ?? "0") || 0;
      const avgScore = totalPlayersCompleted > 0 ? totalScore / totalPlayersCompleted : 0;
      const puzzleSize = parseArchivePuzzleSize(String(mergedData.gameData ?? data.gameData ?? ""));
      const levelName = String(mergedData.levelName ?? "");
      const levelCreator = String(mergedData.levelCreator ?? "");
      const levelTag = String(mergedData.levelTag ?? "");
      const nonStandard = String(mergedData.nonStandard ?? "0") === "1" ? "1" : "0";

      let viewerPlayed = false;
      if (hasViewer) {
        const viewerStateRaw = await redis.get(stateKey(postId, viewerUsername));
        if (viewerStateRaw) {
          try {
            const viewerState = JSON.parse(viewerStateRaw) as { data?: { level_status?: string | number } };
            const levelStatus = Number(viewerState?.data?.level_status ?? 0) || 0;
            viewerPlayed = levelStatus >= 2;
          } catch {
            viewerPlayed = false;
          }
        }
      }

      if (tag && levelTag !== tag) return null;
      if (sizeAtLeastEight) {
        if (puzzleSize < 8) return null;
      } else if (Number.isFinite(normalizedSize) && normalizedSize > 0 && puzzleSize !== normalizedSize) {
        return null;
      }
      if (unplayedOnly && viewerPlayed) return null;
      if (normalizedNonStandard === "standard" && nonStandard === "1") return null;
      if (normalizedNonStandard === "nonstandard" && nonStandard !== "1") return null;
      if (authorFilter && !levelCreator.toLowerCase().includes(authorFilter)) return null;
      if (titleFilter && !levelName.toLowerCase().includes(titleFilter)) return null;

      return {
        postId,
        ...data,
        levelID: String(mergedData.levelID ?? levelID),
        levelName,
        levelCreator,
        levelTag,
        nonStandard,
        totalPlayers,
        totalPlayersCompleted,
        totalScore,
        avgScore,
        puzzleSize,
        viewerPlayed,
        dateValue: archiveDateValue(String(mergedData.levelDate ?? "")),
        karma: 0,
      };
    }))).filter((puzzle): puzzle is NonNullable<typeof puzzle> => Boolean(puzzle));

    if (normalizedSort === "karma") {
      await Promise.all(archivePuzzles.map(async (puzzle) => {
        puzzle.karma = await loadArchiveKarma(puzzle.postId);
      }));
    }

    archivePuzzles.sort((left, right) => {
      if (normalizedSort === "players") {
        return (right.totalPlayers - left.totalPlayers) || (right.dateValue - left.dateValue);
      }
      if (normalizedSort === "avg") {
        return (right.avgScore - left.avgScore) || (right.dateValue - left.dateValue);
      }
      if (normalizedSort === "karma") {
        return (right.karma - left.karma) || (right.dateValue - left.dateValue);
      }
      return (right.dateValue - left.dateValue) || ((Number(right.levelID ?? "0") || 0) - (Number(left.levelID ?? "0") || 0));
    });

    const totalFiltered = archivePuzzles.length;
    const sliceStart = hasPageParam ? (page - 1) * limit : cursor;
    const sliceEnd = sliceStart + limit;
    const pagedPuzzles = archivePuzzles.slice(sliceStart, sliceEnd);

    if (normalizedSort !== "karma") {
      await Promise.all(pagedPuzzles.map(async (puzzle) => {
        puzzle.karma = await loadArchiveKarma(puzzle.postId);
      }));
    }

    const totalPages = Math.max(1, Math.ceil(totalFiltered / limit));
    const nextCursor = Math.min(totalFiltered, sliceStart + pagedPuzzles.length);

    return c.json({
      puzzles: pagedPuzzles,
      nextCursor,
      hasMore: nextCursor < totalFiltered,
      total,
      totalFiltered,
      page: hasPageParam ? Math.min(page, totalPages) : Math.floor(sliceStart / limit) + 1,
      totalPages,
      sort: normalizedSort,
      tag,
      size: Number.isFinite(normalizedSize) && normalizedSize > 0 ? normalizedSize : null,
      nonStandard: normalizedNonStandard,
    });

  } catch (err) {
    console.error("list-levels error:", err);
    return c.json({ error: "Failed to load levels" }, 500);
  }
});


//////////////////////////////////////////////////////////////////////////////


// POST /api/create-user-post -> user created and submitted a puzzle
router.post("/api/create-user-post", async (c) => {

  try {
    console.log("POST /api/create-user-post happening");

    const username = await getUsername();
    //if (!username) return c.json({ error: "Missing username" }, 400);
    if (username === "anonymous") return c.json({ error: "Login required" }, 401);

    const { title, puzzleData, nonStandard } = await c.req.json<any>();

    if (typeof nonStandard !== "string") {
      return c.json({ error: "nonStandard must be a string" }, 400);
    }
    if (typeof title !== "string") {
      return c.json({ error: "title must be a string" }, 400);
    }
    if (typeof puzzleData !== "string") {
      return c.json({ error: "puzzleData must be a string" }, 400);
    }

    console.log('POST /api/create-user-post step 2');

    //console.log(JSON.stringify(data));
    console.log("Incoming puzzleData from client:", puzzleData);

    //add user's puzzle data into a puzzle struct

    const puzzle = {
      levelName: title,
      gameData: puzzleData,
      levelTag: "community",
      levelCreator: username || "unknown",
      nonStandard: nonStandard || "0",
      levelDate: new Date().toISOString(),
      addedAt: Date.now(),
    };

    // Post puzzle using the same function as scheduled job
    //const { createGamePostFromPuzzle } = await import("./actions/createGamePost");
    const post = await createGamePostFromPuzzle(puzzle);

    console.log('post created');

    if (!post) {
      throw new Error("Post creation failed");
    }

    if (post !== null) {

      const timestamp = Date.now();

      await redis.zAdd(`user:${username}:puzzles`, {
        member: post.id,
        score: timestamp
      });

      // increment puzzle count
      // I think this is redundant because zAdd already tracks the puzzles, and also the profile holds the count
      await redis.incrBy(`user:${username}:puzzleCount`, 1);

      await redis.incrBy("globalStats:puzzlesCreatedTotal", 1);

      //now later i could do
      /*
      //Get All Puzzles by User function
      const puzzles = await redis.zRange(
        `user:${username}:puzzles`,
        0,
        -1
      );
      */

      //and
      //const puzzleCount = Number(await redis.get(`user:${username}:puzzleCount`) || 0);

      /////////

      // Update author's user state on this post so that level_status = 4
      await updateState({
        postId: post.id,
        username,
        data: {
          level_status: "4",
        },
      });


      //now update user's profile with new count and postId
      try {
        const profile = await getUserProfile(username);
        const prevProfileData = profile?.profileData ?? {};

        // --- created_total ---
        const prevTotal = Number(prevProfileData.created_total) || 0;
        const created_total = String(prevTotal + 1);

        // --- created_ids ---
        // normalize -1 being empty
        let ids: string[] = [];

        if (prevProfileData.created_ids && prevProfileData.created_ids !== "-1") {
          ids = prevProfileData.created_ids.split(",");
        }

        // prevent duplicates
        if (!ids.includes(post.id)) {
          ids.push(post.id);
        }

        const created_ids = ids.length > 0 ? ids.join(",") : "-1";

        await saveUserProfile({
          username,
          profileData: {
            created_total,
            created_ids,
          },
          updatedBy: username,
        });

        console.log('profile updated');
      } catch (e) {
        console.error("Profile update failed:", e);
      }


      //

      console.log('navigateTo new post');

      //navigateTo(`https://reddit.com/r/${context.subredditName}/comments/${post.id}`);
    }

    return c.json({
      success: true,
      message: 'Post created successfully',
      result: `${post.id}`,
      navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
    });
  } catch (err) {
    console.error("POST /api/create-user-post error:", err);
    return c.json({ error: "Failed to create-user-post" }, 500);
  }
});


/////////








// router.get("/api/internal/redis", async (c) => {
//   try {
//     const key = c.req.query("key") as string;

//     if (!key) {
//       return c.json({
//         usage: "/internal/redis?key=YOUR_KEY"
//       });
//     }

//     const type = await redis.type(key);

//     let data: any = null;

//     switch (type) {

//       case "string":
//         data = await redis.get(key);
//         break;

//       case "hash":
//         data = await redis.hGetAll(key);
//         break;

//       case "zset":
//         data = await redis.zRange(key, 0, -1, { WITHSCORES: true });
//         break;

//       case "set":
//         data = await redis.sMembers(key);
//         break;

//       case "list":
//         data = await redis.lRange(key, 0, -1);
//         break;

//       default:
//         data = null;
//     }

//     res.json({
//       key,
//       type,
//       data
//     });

//   } catch (err) {

//     console.error("Redis debug error:", err);

//     return c.json({
//       error: "failed"
//     }, 500);

//   }
// });


// router.get("/api/internal/redis-scan", async (c) => {
//   try {

//     const keys: string[] = [];

//     for await (const key of redis.scanIterator({
//       match: "*",
//       count: 100
//     })) {
//       keys.push(key);
//     }

//     res.json(keys);

//   } catch (err) {
//     console.error("Redis scan failed:", err);

//     return c.json({
//       error: String(err)
//     }, 500);
//   }
// });




//////////////////////////////////////////////////////////////////////////////



router.post('/api/join-subreddit', async (c) => {
  try {
    // subscribe the current user
    await reddit.subscribeToCurrentSubreddit();

    // get the current user
    const user = await reddit.getCurrentUser();
    if (!user) return c.json({ status: 'error', message: 'User not found' }, 401);
    const username = user.username;

    // update profile.profileData.profile_joined
    await saveUserProfile({
      username,
      profileData: {
        profile_joined: "1",
      },
      updatedBy: username,
    });

    return c.json({ status: 'success' });
  } catch (error) {
    console.error("Join failed:", error);

    return c.json({
      status: 'error',
      message: 'Failed to subscribe'
    }, 500);
  }
});


router.get('/api/subscription-status', async (c) => {
  try {
    const user = await reddit.getCurrentUser();
    if (!user) return c.json({ subscribed: false }, 200);
    const username = user.username;

    const profile = await getUserProfile(username);

    const joined = profile?.profileData?.profile_joined ?? "0";

    return c.json({
      subscribed: joined === "1"
    });

  } catch (error) {
    console.error("Subscription check failed:", error);

    return c.json({
      subscribed: false
    });
  }
});




////////////////////////////////////////////////////////////////////////////



router.get("/api/get-create-post", async (c) => {
  const [id, url] = await Promise.all([
    redis.get("createPostID"),
    redis.get("createPostURL"),
  ]); 

  return c.json({
    id: id ?? null,
    url: url ?? null,
  });
});



// ##########################################################################

router.post("/internal/on-app-install", async (c) => {
  try {
    const post = await createPost();

    return c.json({
      status: "success",
      message: `Post created in subreddit ${context.subredditName} with id ${post.id}`,
    });
  } catch (error) {
    console.error(`Error creating post: ${error}`);
    return c.json({
      status: "error",
      message: "Failed to create post",
    }, 400);
  }
});

router.post("/internal/menu/post-create", async (c) => {
  try {
    const post = await createPost();

    return c.json({
      navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
    });
  } catch (error) {
    console.error(`Error creating post: ${error}`);
    return c.json({
      status: "error",
      message: "Failed to create post",
    }, 400);
  }
});

///////////

// import { scheduler } from '@devvit/web/server';

// router.post('/internal/scheduler/auto-post-puzzle', async (c) => {
//   console.log(`Handle event for cron example at ${new Date().toISOString()}!`);
//   // Handle the event here
//   return c.json({ status: 'ok' }, 200);
// });



// Handle the occurrence of the event
// router.post('/internal/scheduler/one-off-task-example', async (c) => {
//   const oneMinuteFromNow = new Date(Date.now() + 1000 * 60);

//   let scheduledJob: ScheduledJob = {
//     id: `job-one-off-for-post${postId}`,
//     name: 'one-off-task-example',
//     data: { postId },
//     runAt: oneMinuteFromNow,
//   };

//   let jobId = await scheduler.runJob(scheduledJob);
//   console.log(`Scheduled job ${jobId} for post ${postId}`);
//   console.log(`Handle event for one-off event at ${new Date().toISOString()}!`);
//   // Handle the event here
//   return c.json({ status: 'ok' }, 200);
// });


//////

serve({
  fetch: app.fetch,
  createServer,
  port: getServerPort(),
});
