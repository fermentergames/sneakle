import express from "express";
import { InitResponse } from "../shared/types/api";
import {
  createServer,
  context,
  getServerPort,
  reddit,
  redis
} from "@devvit/web/server";
import { RunAs } from '@devvit/public-api';
import { createPost } from "./core/post";
// import { navigateTo } from '@devvit/web/client';
//import {registerDebugRoutes} from './debugApi';
import { Logger } from './utils/Logger';

import { getCurrentDailyCount, getCurrentLevelCount } from "../actions/createGamePost";
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
//

//import { registerPuzzleMenuActions } from "./actions/menuActions";
//import { addPuzzleForm } from "./actions/addPuzzleToDailyQueue";

import { menuActions } from "./actions/menuActions";
//import { addPuzzleForm } from "./actions/formHandler"; // your form POST/GET handlers
//import { puzzleMenuActions } from './actions/puzzleMenuActions';

import { createGamePostFromPuzzle } from "./actions/createGamePost";



/* ========== End Focus - Import action files ========== */



const app = express();

// Middleware for JSON body parsing
app.use(express.json());
// Middleware for URL-encoded body parsing
app.use(express.urlencoded({ extended: true }));
// Middleware for plain text body parsing
app.use(express.text());

const router = express.Router(); 

/* ========== Start Focus - Register game actions ========== */
//menuActionOld(router);
//formAction(router);
//scheduledAction(router);
//initGameAction(router);
//
//scheduledPuzzlePostActionOld(router);
scheduledPuzzlePostAction(router);
resyncUserProfilesJob(router);

//registerPuzzleMenuActions(router);
//addPuzzleForm(router);

// ==== Menu Items + Form Handlers ====
menuActions(router);

// ==== Form Handlers ====
//addPuzzleForm(router);


/* ========== End Focus - Register game actions ========== */


//

//init is called by main.ts in client
router.get<
  { postId: string },
  InitResponse | { status: string; message: string }
>("/api/init", async (_req, res): Promise<void> => {

  console.log("app/init happening in index.ts");

  const { postId } = context;

  if (!postId) {
    console.error("API Init Error: postId not found in devvit context");
    res.status(400).json({
      status: "error",
      message: "postId is required but missing from context",
    });
    return;
  }

  try {
    const username = await reddit.getCurrentUsername();

    res.json({
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
    res.status(400).json({ status: "error", message: errorMessage });
  }
});

// Add your game-specific API endpoints here
// Examples:
// router.post("/api/save-score", async (req, res) => { ... });
// router.get("/api/leaderboard", async (req, res) => { ... });
// router.post("/api/game-event", async (req, res) => { ... });

// ##########################################################################
// # DEMO SAMPLE: State + Score + Leaderboard using Redis
// ##########################################################################

type StoredState = {
  username: string;
  data?: Record<string, unknown>;
  updatedAt: number;
};

type StoredProfile = {
  username: string;
  profileData?: Record<string, unknown>;
  updatedBy: string;
  updatedAt: number;
};

type StoredPostData = {
  data?: Record<string, unknown>;
  updatedAt: number; 
};


function stateKey(postId: string, username: string) {
  return `state:${postId}:${username}`;
}
function userProfileKey(username: string) {
  return `profile:${username}`;
}
function leaderboardKey(postId: string) {
  return `lb:${postId}`;
}
async function getUsername(): Promise<string> {
  const u = await reddit.getCurrentUsername();
  return u ?? "anonymous";
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
router.get("/api/state", async (req, res) => {
  try {
    // const { postId } = context;
    // if (!postId) return res.status(400).json({ error: "Missing postId in context" });

    //console.log("get /api/state happening");
    //console.log("query.postId:", req.query.postId);

    // 1. Explicit override always wins
    const queryPostId =
      typeof req.query.postId === "string" && req.query.postId.trim() !== ""
        ? req.query.postId
        : undefined;

    //console.log("req.query.postId = "+req.query.postId+" (empty means use current context postId)");

    // 2. Fallback to context if it exists
    const postId = queryPostId ?? context.postId;

    
    //console.log("postId = "+postId);


    // 3. If still missing, this request is NOT in post context
    if (!postId || postId == undefined) {
      return res.status(400).json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      });
    }

    //console.log("GET /api/state for postId "+postId);

    const username = await getUsername();
    const key = stateKey(postId, username);
    const stateRaw = await redis.get(key);
    //if (!stateJson) return res.status(404).json({ error: "No state found" });

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

    res.json(response);


  } catch (err) {
    console.error("GET /api/state error:", err);
    res.status(500).json({ error: "Failed to fetch state" });
  }
});

// POST /api/state?postId=t3_abc123 -> upsert current user's state for this postId
router.post("/api/state", async (req, res) => {
  try {

    // 1. Prefer explicit postId from request
    const requestedPostId =
      typeof req.query.postId === "string" ? req.query.postId : undefined;

    // 2. Fallback to context postId
    const postId = requestedPostId ?? context.postId;

    if (!postId) {
      return res.status(400).json({ error: "Missing postId" });
    }

    const username = await getUsername();
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    console.log("POST /api/state happening for user: "+username+" at postId: "+postId);

    const { data } = req.body ?? {};

    console.log("Posting State data:\n" + JSON.stringify(data, null, 2));

    if (data !== undefined && (typeof data !== "object" || data === null)) {
      return res.status(400).json({ error: "data must be an object" });
    }
    
    const next = await updateState({ postId, username, data });

    res.json(next);

    //

  } catch (err) {
    console.error("POST /api/state error:", err);
    res.status(500).json({ error: "Failed to save state" });
  }
});


/////end of state stuff






///////////////profile stuff


//helper functions

async function getUserProfile(username: string) {
  const key = userProfileKey(username);

  const raw = await redis.get(key);
  return raw ? JSON.parse(raw) : null;
}

async function updateUserProfileData({
  username,
  profileData,
}: {
  username: string;
  profileData: Record<string, any>;
}) {

  const key = userProfileKey(username);

  const prevRaw = await redis.get(key);
  const prev = prevRaw ? JSON.parse(prevRaw) : {};

  // build the new profile; only include optional fields if they exist 
  const next = {
    ...prev,
    profileData: {
      ...(prev.profileData ?? {}),
      ...profileData,
    },
    username,
    updatedBy: username || "anonymous",
    updatedAt: new Date().toISOString(),
  };

  await redis.set(key, JSON.stringify(next));
  return next;
}

//


// GET /api/profile -> fetch current user's state for profile 
router.get("/api/profile", async (req, res) => {
  try {
    console.log('GET /api/profile happening', { query: req.query });

    const username = await getUsername();
    //if (!username) return res.status(400).json({ error: "Missing username" });
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const key = userProfileKey(username);

    //console.log(key);

    const profile = await getUserProfile(username);

    const d = profile?.profileData ?? {};

    console.log(JSON.stringify(d));

    console.log(`GET /api/profile worked for user: ${username}`, { query: req.query });
    //res.status(200).json({ ok: true });

    res.json({
      type: "profile",

      stat_d_total_started    : d.stat_d_total_started ?? "0",
      stat_d_total_finished : d.stat_d_total_finished ?? "0",
      stat_d_total_gaveup   : d.stat_d_total_gaveup ?? "0",
      stat_d_total_score    : d.stat_d_total_score ?? "0",
      stat_d_total_time     : d.stat_d_total_time ?? "0",
      stat_d_total_guesses    : d.stat_d_total_guesses ?? "0",
      stat_d_total_hints    : d.stat_d_total_hints ?? "0",

      stat_c_total_started    : d.stat_c_total_started ?? "0",
      stat_c_total_finished : d.stat_c_total_finished ?? "0",
      stat_c_total_gaveup   : d.stat_c_total_gaveup ?? "0",
      stat_c_total_score    : d.stat_c_total_score ?? "0",
      stat_c_total_time     : d.stat_c_total_time ?? "0",
      stat_c_total_guesses    : d.stat_c_total_guesses ?? "0",
      stat_c_total_hints    : d.stat_c_total_hints ?? "0",

      stat_u_total_started    : d.stat_u_total_started ?? "0",
      stat_u_total_finished : d.stat_u_total_finished ?? "0",
      stat_u_total_gaveup   : d.stat_u_total_gaveup ?? "0",
      stat_u_total_score    : d.stat_u_total_score ?? "0",
      stat_u_total_time     : d.stat_u_total_time ?? "0",
      stat_u_total_guesses    : d.stat_u_total_guesses ?? "0",
      stat_u_total_hints    : d.stat_u_total_hints ?? "0",

      created_total    : d.created_total ?? "0",
      created_ids    : d.created_ids ?? "-1",

      option_darkmode     : d.option_darkmode ?? "1",
      option_sfx          : d.option_sfx ?? "1",
      option_show_timer   : d.option_show_timer ?? "1",

      profile_joined   : d.profile_joined ?? "0",

      username: username ?? "anonymous",
    });


    //console.log(json);

  } catch (err) {
    console.error(`GET /api/profile error for user: ${username} -- `, err);
    res.status(500).json({ error: "Failed to fetch profile for user" });
  }
});


// POST /api/profile -> upsert current user's state for profile
router.post("/api/profile", async (req, res) => {
  try {

    console.log('POST /api/profile happening', { query: req.query });

    const username = await getUsername();
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const { profileData } = req.body ?? {};

    if (profileData !== undefined && (typeof profileData !== "object" || profileData === null)) {
      return res.status(400).json({ error: "profileData must be an object" });
    }
    
    const next = await updateUserProfileData({
      username,
      profileData: profileData ?? {},
    });

    console.log(JSON.stringify(next));


    /* only update flair if updated profileData includes "stat_d_total_score", because that's what is counted */

    const shouldUpdateFlair =
      profileData && Object.prototype.hasOwnProperty.call(profileData, "stat_d_total_score");

    /* UPDATE USER FLAIR AFTER SAVING PROFILE */

    if (shouldUpdateFlair) {
      try {

        let flairTextStart = ""
        let flairBGColor = "#36C95D"
        if (next.profileData.created_total >= 1) {
          flairTextStart = "Puzzle Maker 🔠✏️"
          flairBGColor = "#DD8F22"
        } else {
          flairTextStart = "Sneakler 🔠"
          flairBGColor = "#36C95D"
        }

        let flairText = `${flairTextStart} - Total Score: ${next.profileData.stat_d_total_score}`

        console.log(`flairText = ${flairText}`);

        if (username === "FermenterGames") { 
          //skip
          console.log(`Flair update SKIPPED for user: ${username}`);

        } else {

          await reddit.setUserFlair({
            subredditName: `${context.subredditName}`,
            username: username,
            text: flairText,
            backgroundColor: flairBGColor,
            textColor: "dark"
          });
          
          console.log(`Flair updated for user: ${username}`);
        }
      } catch (error) {
        console.error(`Failed to set flair for user: ${username} --`, error);
      }
    }


    


    console.log('POST /api/profile complete');

    res.json(next);
  } catch (err) {
    console.error("POST /api/profile error:", err);
    res.status(500).json({ error: "Failed to save profile for user" });
  }
});

//end of profile


// GET /api/load-post-data -> load postData for this post
router.get('/api/load-post-data', async (req, res): Promise<void> => {

    console.log("app/load-post-data happening");

    // Create a logger
    const logger = await Logger.Create('API - Load Post Data');
    logger.traceStart('API Action');

    try {

      logger.info("Load Post Data happening");

      /* ========== Start Focus - Fetch from redis + return result ========== */

      // 1. Explicit override always wins
      const queryPostId =
        typeof req.query.postId === "string" && req.query.postId.trim() !== ""
          ? req.query.postId
          : undefined;

      logger.info("req.query.postId = "+req.query.postId+" (empty means use current context postId)");

      // 2. Fallback to context if it exists
      const postId = queryPostId ?? context.postId;

      logger.info("postId = "+postId);


      // 3. If still missing, this request is NOT in post context
      if (!postId || postId == undefined) {
        return res.status(400).json({
          error:
            "postId missing: this endpoint was called outside of post context and no postId was provided",
        });
      }

      // 4. Fetch the post explicitly
      const post = await reddit.getPostById(postId);
      const postData = await post.getPostData();

      // Confirm post data and level name exists
      //const { postData } = context;
      if (!postData || !postData.levelName || typeof postData.levelName !== 'string') {
        logger.error('API Load Post Data Error: postData.levelName not found in devvit context');
        res.status(400).json({
          status: 'error',
          message: 'postData.levelName is required but missing from context',
        });
        return;
      }

      // Fail if level data is missing
      if (!postData.gameData) {
        logger.error('API Load Post Data Error: gameData not found in redis');
        res.status(400).json({
          status: 'error',
          message: 'gameData is required but missing from redis',
        });
        return;
      }

      logger.info("postData = "+JSON.stringify(postData));

      // Otherwise, return data back to post!
      res.json({
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
      res.status(400).json({
        status: 'error',
        message: 'Load Post Data action failed'
      });
    } finally {
      logger.traceEnd();
    }
});


// POST /api/update-post-data -> submit/update postData for this post
router.post("/api/update-post-data", async (req, res) => {

  // 1. Explicit override always wins
  const queryPostId =
    typeof req.query.postId === "string" && req.query.postId.trim() !== ""
      ? req.query.postId
      : undefined;

  // 2. Fallback to context if it exists
  const postId = queryPostId ?? context.postId;

  // 3. If still missing, this request is NOT in post context
  if (!postId) {
    return res.status(400).json({
      error:
        "postId missing: this endpoint was called outside of post context and no postId was provided",
    });
  }

  try {
    console.log("POST /api/update-post-data happening for postId "+postId, { query: req.query });

    const username = await getUsername();
    //if (!username) return res.status(400).json({ error: "Missing username" });
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const { data } = req.body ?? {};

    if (data !== undefined && (typeof data !== "object" || data === null)) {
      return res.status(400).json({ error: "data must be an object" });
    }

    console.log('POST /api/update-post-data step 2');

    console.log(JSON.stringify(data));


    const post = await reddit.getPostById(postId);

    // Get existing post data to merge with updates
    const currentData = (await post.getPostData()) ?? {};

    const merged = {
      ...currentData,
      ...(data ?? {}),
      lastUpdatedBy: username || 'anonymous',
      lastUpdatedAt: new Date().toISOString(),
    };

    await post.setPostData(merged);

    res.json({
      success: true,
      message: 'Post data updated successfully'
    });
  } catch (err) {
    console.error("POST /api/update-post-data error:", err);
    res.status(500).json({ error: "Failed to update-post-data" });
  }
});

// POST /api/score -> submit/update best score for this post
router.post("/api/score", async (req, res) => {
  try {


    // 1. Explicit override always wins
    const queryPostId =
      typeof req.query.postId === "string" && req.query.postId.trim() !== ""
        ? req.query.postId
        : undefined;

    // 2. Fallback to context if it exists
    const postId = queryPostId ?? context.postId;

    // 3. If still missing, this request is NOT in post context
    if (!postId) {
      return res.status(400).json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      });
    }

    const username = await getUsername();
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const { score } = req.body ?? {};
    if (typeof score !== "number" || !Number.isFinite(score)) {
      return res.status(400).json({ error: "score must be a finite number" });
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

    res.json({ username, score: best, updatedAt: updatedAt });
  } catch (err) {
    console.error("POST /api/score error:", err);
    res.status(500).json({ error: "Failed to submit score" });
  }
});






// POST /api/leaderboard-comment
router.post("/api/leaderboard-comment", async (req, res) => {
  try {

    console.log("api/leaderboard-comment happening");

    // const queryPostId =
    //   typeof req.query.postId === "string" && req.query.postId.trim() !== ""
    //     ? req.query.postId
    //     : undefined;

    //   console.log("comment-score happening")

    // const postId = queryPostId ?? context.postId;
    // if (!postId) return res.status(400).json({ error: "postId missing" });


    const postId =
      typeof req.query.postId === "string" && req.query.postId.trim() !== ""
        ? req.query.postId.trim()
        : null;

    if (!postId) {
      return res.status(400).json({ error: "Valid postId required" });
    }

    console.log("Incoming postId:", req.query.postId);
    console.log("Using postId:", postId);

    const lbKey = leaderboardKey(postId);

    // Get total leaderboard size
    const total = await redis.zCard(lbKey); // number of members
    if (total === 0) {
      console.log("Leaderboard empty, nothing to update");
      return res.json({ message: "Leaderboard empty" });
    }

    const limitParam = 10; //Number(req.query.limit ?? 10);
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
    const post = await reddit.getPostById(postId);
    const postData = await post.getPostData();

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
    //     .map((entry) => `**${entry.rank}. ${entry.username}** — ${entry.score} pts`)
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
      const comments = await reddit.getComments({ postId }).all();

      //console.log(JSON.stringify(comments))

      //c.author?.name === "sneaklebot" && 

      const lbComment = comments.find(
        (c) => c.body?.includes(MARKER)
      );

      if (lbComment) {
        await lbComment.edit({ text: leaderboardMarkdown });
      } else {
        const comment = await reddit.submitComment({
          id: postId,
          text: leaderboardMarkdown,
        });
        await comment.distinguish(true);
      }
    } catch (redditErr) {
      console.error("Error updating leaderboard comment inner:", redditErr);
      return res.status(500).json({ error: "Failed to update leaderboard comment inner" });
    }

    res.json({ message: "Leaderboard comment updated"});
  } catch (err) {
    console.error("Leaderboard comment endpoint error:", err);
    res.status(500).json({ error: "Failed to update leaderboard comment" });
  }
});





// POST /api/comment-score
router.post("/api/comment-score", async (req, res) => {
  try {

    console.log("api/comment-score happening");

    // const queryPostId =
    //   typeof req.query.postId === "string" && req.query.postId.trim() !== ""
    //     ? req.query.postId
    //     : undefined;

    //   console.log("comment-score happening")

    // const postId = queryPostId ?? context.postId;
    // if (!postId) return res.status(400).json({ error: "postId missing" });


    const postId =
      typeof req.query.postId === "string" && req.query.postId.trim() !== ""
        ? req.query.postId.trim()
        : null;

    if (!postId) {
      return res.status(400).json({ error: "Valid postId required" });
    }

    console.log("Incoming postId:", req.query.postId);
    console.log("Using postId:", postId);

    const { score } = req.body ?? {};
    if (score === undefined || score === null)
      return res.status(400).json({ error: "score missing" });

    const username = await getUsername();
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const MARKER = "Leaderboard (Top 10)";

    try {
      const comments = await reddit.getComments({ postId }).all();

      const lbComment = comments.find((c) =>
        c.body?.includes(MARKER)
      );

      if (!lbComment) {
        return res.status(404).json({ error: "Leaderboard comment not found" });
      }

      const scoreComment = `🎯 **${username}** scored **${score}** points on this Sneakle!`;

      // Reply AS THE USER
      // await reddit.asUser().submitComment({
      //   id: lbComment.id,
      //   text: scoreComment,
      // });

      const comment = await reddit.submitComment({
       id: lbComment.id,
       text: scoreComment,
       runAs: 'USER',
      })

      res.json({ message: "Score comment posted" });
    } catch (redditErr) {
      console.error("Error posting user score comment:", redditErr);
      return res.status(500).json({ error: "Failed to post user score comment" });
    }
  } catch (err) {
    console.error("comment-score endpoint error:", err);
    res.status(500).json({ error: "Failed to comment-score" });
  }
});


/////


// GET /api/leaderboard?limit=10 -> top N + caller's rank 
router.get("/api/leaderboard", async (req, res) => {
  try {
    const queryPostId =
      typeof req.query.postId === "string" && req.query.postId.trim() !== ""
        ? req.query.postId
        : undefined;

    const postId = queryPostId ?? context.postId;

    if (!postId) {
      return res.status(400).json({
        error:
          "postId missing: this endpoint was called outside of post context and no postId was provided",
      });
    }

    const username = await getUsername();
    const lbKey = leaderboardKey(postId);

    const limitParam = Number(req.query.limit ?? 10);
    const limitTop = Number.isFinite(limitParam) ? Math.max(1, Math.min(limitParam, 100)) : 10;

    // 1️⃣ total players
    const total = Number((await redis.zCard(lbKey)) ?? 0);

    // // -. Fetch the post explicitly
    // const post = await reddit.getPostById(postId);
    // const postData = await post.getPostData();

    // const postDataTotal = postData.totalPlayers
    // if (total > postDataTotal) {
    //   // update postData.totalPlayers
    // }

    if (total === 0) {
      return res.json({
        top: [],
        aroundMe: [],
        me: null,
        totalPlayers: 0,
        generatedAt: Date.now(),
      });
    }

    // 2️⃣ get top 15 (ascending slice from end)
    const topStart = Math.max(0, total - limitTop);
    const topAsc = await redis.zRange(lbKey, topStart, total - 1);

    const top = topAsc.toReversed().map((e, i) => {
      const ascIndex = topStart + (topAsc.length - 1 - i);
      return {
        rank: total - ascIndex,
        username: e.member,
        score: Number(e.score ?? 0),
      };
    });



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
    }

    res.json({
      top,
      aroundMe,
      me,
      totalPlayers: total,
      generatedAt: Date.now(),
    });
  } catch (err) {
    console.error("GET /api/leaderboard error:", err);
    res.status(500).json({ error: "Failed to fetch leaderboard" });
  }
});



///////////////////////


// GET /api/get-surrounding-daily-ids -> load postData for this post
router.get('/api/get-surrounding-daily-ids', async (req, res): Promise<void> => {

    console.log("app/get-surrounding-daily-ids happening");

    // Create a logger
    const logger = await Logger.Create('API - Get Surrounding Daily IDs');
    logger.traceStart('API Action');

    try {

      /* ========== Start Focus - Fetch from redis + return result ========== */

      // 1. Explicit override always wins
      const queryPostId =
        typeof req.query.postId === "string" && req.query.postId.trim() !== ""
          ? req.query.postId
          : undefined;

      logger.info("req.query.postId = "+req.query.postId+" (empty means use current context postId)");

      // 2. Fallback to context if it exists
      const postId = queryPostId ?? context.postId;

      // 3. If still missing, this request is NOT in post context
      if (!postId) {
        return res.status(400).json({
          error:
            "postId missing: this endpoint was called outside of post context and no postId was provided",
        });
      }

      const { prev, next, today } = await getPrevNextDailyPost(postId, logger);

      logger.info("daily_prev_postId = "+prev);
      logger.info("daily_next_postId = "+next);
      logger.info("daily_today_postId = "+today);

      // Otherwise, return data back to post!
      res.json({
        daily_prev_postId: prev ?? "-9999",
        daily_next_postId: next ?? "-9999",
        daily_today_postId: today ?? "-9999",
      });

      /* ========== End Focus - Fetch from redis + return result ========== */

    } catch (error) {
      logger.error('Error in get-surrounding-daily-ids action: ', error);
      res.status(400).json({
        status: 'error',
        message: 'Load Post Data action failed'
      });
    } finally {
      logger.traceEnd();
    }
});

//////////////////////////////////////////////////////////////////////////////


router.get("/api/list-levels", async (req, res) => {
  try {
    const cursorParam = Number(req.query.cursor ?? 0);
    const limitParam = Number(req.query.limit ?? 10);
    const tag = req.query.tag;

    const cursor = Number.isFinite(cursorParam) ? Math.max(0, cursorParam) : 0;
    const limit = Number.isFinite(limitParam)
      ? Math.max(1, Math.min(limitParam, 50))
      : 10;

    const total = await redis.zCard("levelList");

    if (total === 0) {
      return res.json({ puzzles: [], nextCursor: cursor, hasMore: false, total: 0 });
    }

    let puzzles = [];
    let scanned = 0; // how many we've walked past (for cursor)

    while (puzzles.length < limit && (cursor + scanned) < total) {

      // Compute next index from END (newest first)
      const indexFromEnd = cursor + scanned;

      const start = total - indexFromEnd - 1;
      const end = start;

      const items = await redis.zRange("levelList", start, end);

      if (!items || items.length === 0) break;

      const item = items[0];
      const postId = item.member;

      const levelID = await redis.get(`post:${postId}:levelID`);
      if (!levelID) {
        scanned++;
        continue;
      }

      const data = await redis.hGetAll(`puzzle:${levelID}`);
      if (!data || Object.keys(data).length === 0) {
        scanned++;
        continue;
      }

      const puzzle = { postId, ...data };

      if (!tag || puzzle.levelTag === tag) {
        puzzles.push(puzzle);
      }

      scanned++;
    }

    const nextCursor = cursor + scanned;

    res.json({
      puzzles,
      nextCursor,
      hasMore: nextCursor < total,
      total,
    });

  } catch (err) {
    console.error("list-levels error:", err);
    res.status(500).json({ error: "Failed to load levels" });
  }
});


//////////////////////////////////////////////////////////////////////////////


// POST /api/create-user-post -> user created and submitted a puzzle
router.post("/api/create-user-post", async (req, res) => {

  try {
    console.log("POST /api/create-user-post happening");

    const username = await getUsername();
    //if (!username) return res.status(400).json({ error: "Missing username" });
    if (username === "anonymous") return res.status(401).json({ error: "Login required" });

    const { title, puzzleData, nonStandard } = req.body ?? {};

    if (typeof nonStandard !== "string") {
      return res.status(400).json({ error: "nonStandard must be a string" });
    }
    if (typeof title !== "string") {
      return res.status(400).json({ error: "title must be a string" });
    }
    if (typeof puzzleData !== "string") {
      return res.status(400).json({ error: "puzzleData must be a string" });
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

        await updateUserProfileData({
          username,
          profileData: {
            created_total,
            created_ids,
          },
        });

        console.log('profile updated');
      } catch (e) {
        console.error("Profile update failed:", e);
      }


      //

      console.log('navigateTo new post');

      //navigateTo(`https://reddit.com/r/${context.subredditName}/comments/${post.id}`);
    }

    res.json({
      success: true,
      message: 'Post created successfully',
      result: `${post.id}`,
      navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
    });
  } catch (err) {
    console.error("POST /api/create-user-post error:", err);
    res.status(500).json({ error: "Failed to create-user-post" });
  }
});


/////////








// router.get("/api/internal/redis", async (req, res) => {
//   try {
//     const key = req.query.key as string;

//     if (!key) {
//       return res.json({
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

//     res.status(500).json({
//       error: "failed"
//     });

//   }
// });


// router.get("/api/internal/redis-scan", async (_req, res) => {
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

//     res.status(500).json({
//       error: String(err)
//     });
//   }
// });




//////////////////////////////////////////////////////////////////////////////



router.post('/api/join-subreddit', async (_req, res) => {
  try {
    // subscribe the current user
    await reddit.subscribeToCurrentSubreddit();

    // get the current user
    const user = await reddit.getCurrentUser();
    const username = user.username;

    // update profile.profileData.profile_joined
    await updateUserProfileData({
      username,
      profileData: {
        profile_joined: "1",
      },
    });

    res.json({ status: 'success' });
  } catch (error) {
    console.error("Join failed:", error);

    res.status(500).json({
      status: 'error',
      message: 'Failed to subscribe'
    });
  }
});


router.get('/api/subscription-status', async (_req, res) => {
  try {
    const user = await reddit.getCurrentUser();
    const username = user.username;

    const profile = await getUserProfile(username);

    const joined = profile?.profileData?.profile_joined ?? "0";

    res.json({
      subscribed: joined === "1"
    });

  } catch (error) {
    console.error("Subscription check failed:", error);

    res.json({
      subscribed: false
    });
  }
});




////////////////////////////////////////////////////////////////////////////



router.get("/api/get-create-post", async (_req, res) => {
  const [id, url] = await Promise.all([
    redis.get("createPostID"),
    redis.get("createPostURL"),
  ]); 

  res.json({
    id: id ?? null,
    url: url ?? null,
  });
});



// ##########################################################################

router.post("/internal/on-app-install", async (_req, res): Promise<void> => {
  try {
    const post = await createPost();

    res.json({
      status: "success",
      message: `Post created in subreddit ${context.subredditName} with id ${post.id}`,
    });
  } catch (error) {
    console.error(`Error creating post: ${error}`);
    res.status(400).json({
      status: "error",
      message: "Failed to create post",
    });
  }
});

router.post("/internal/menu/post-create", async (_req, res): Promise<void> => {
  try {
    const post = await createPost();

    res.json({
      navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
    });
  } catch (error) {
    console.error(`Error creating post: ${error}`);
    res.status(400).json({
      status: "error",
      message: "Failed to create post",
    });
  }
});

///////////

// import { scheduler } from '@devvit/web/server';

// router.post('/internal/scheduler/auto-post-puzzle', async (req, res) => {
//   console.log(`Handle event for cron example at ${new Date().toISOString()}!`);
//   // Handle the event here
//   res.status(200).json({ status: 'ok' });
// });



// Handle the occurrence of the event
// router.post('/internal/scheduler/one-off-task-example', async (req, res) => {
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
//   res.status(200).json({ status: 'ok' });
// });


//////

app.use(router);

const server = createServer(app);
server.on("error", (err) => console.error(`server error; ${err.stack}`));
server.listen(getServerPort());
