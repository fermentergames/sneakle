import { Hono } from "hono";
import { Logger } from "../utils/Logger";
import { enqueuePuzzle, getQueue, dequeuePuzzle, clearQueue, replaceQueue, isPostingEnabled, togglePostingEnabled } from "../utils/puzzleQueueHelpers";
import { context, reddit, redis } from "@devvit/web/server";
import crypto from "crypto";
import { getCurrentDailyCount } from "../actions/createGamePost";
import { buildProfileEditorFields, extractProfileDataFromForm, getUserProfile, saveUserProfile } from "../utils/profileHelpers";

//

function getNextDailyRun(hourUTC: number): Date {
  const now = new Date();
  const next = new Date(now);
  next.setUTCHours(hourUTC, 0, 0, 0);

  if (next <= now) {
    next.setUTCDate(next.getUTCDate() + 1);
  }

  return next;
}

export const menuActions = (router: Hono): void => {

  router.post("/internal/menu/edit-user-profile", async (c) => {
    const logger = await Logger.Create("Menu - Edit User Profile");
    logger.traceStart("Menu Action");

    try {
      return c.json({
        showForm: {
          name: "loadUserProfileForm",
          form: {
            fields: [
              {
                type: "string",
                name: "username",
                label: "Username to load",
                required: true,
              },
            ],
          },
        },
      });
    } catch (error) {
      logger.error("Menu action error:", error);
      return c.json({
        showToast: { text: "Failed to open user profile loader" },
      });
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/form/load-user-profile", async (c) => {
    const logger = await Logger.Create("Form - Load User Profile");
    logger.traceStart("Form Submit");

    try {
      const values = await c.req.json<any>();
      const username = typeof values.username === "string" ? values.username.trim() : "";

      if (!username) {
        return c.json({
          showToast: { text: "Username is required" },
        }, 400);
      }

      const profile = await getUserProfile(username);

      return c.json({
        showForm: {
          name: "editUserProfileForm",
          form: {
            title: `Edit profile: ${username}`,
            fields: buildProfileEditorFields(username, profile),
          },
        },
      });
    } catch (error) {
      logger.error("Load profile form failed", error);
      return c.json({
        showToast: { text: "Failed to load user profile" },
      }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/form/edit-user-profile", async (c) => {
    const logger = await Logger.Create("Form - Edit User Profile");
    logger.traceStart("Form Submit");

    try {
      const values = await c.req.json<any>();
      const username = typeof values.username === "string" ? values.username.trim() : "";

      if (!username) {
        return c.json({
          showToast: { text: "Username is required" },
        }, 400);
      }

      const actorUsername = await reddit.getCurrentUsername();
      const next = await saveUserProfile({
        username,
        profileData: extractProfileDataFromForm(values),
        updatedBy: actorUsername ?? "anonymous",
      });

      logger.info("Updated user profile", next);

      return c.json({
        showToast: { text: `Saved profile for ${username}` },
      });
    } catch (error) {
      logger.error("Edit profile form failed", error);
      return c.json({
        showToast: { text: "Failed to save user profile" },
      }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/menu/resync-user-profiles", async (c) => {
    const logger = await Logger.Create("Menu - Resync Profiles");
    logger.traceStart("Resync Profiles");

    try {
      // --- Build your dataset (same as before) ---
      const postIds = await redis.zRange("levelList", 0, -1);
      const postIdsStrings = postIds.map(p => p.member);

      const postTagMap: Record<string, string> = {};
      const postCreatorMap: Record<string, string> = {};
      const postTimestampMap: Record<string, number> = {};
      const usernameSet = new Set<string>();

      for (const entry of postIds) {
        const postId = entry.member;
        const levelID = entry.score;

        const puzzleData = await redis.hGetAll(`puzzle:${levelID}`);
        const levelTag = puzzleData?.levelTag ?? "missing";

        postTagMap[postId] = levelTag;

        postCreatorMap[postId] = puzzleData?.levelCreator ?? "SneakleBot";

        // timestamp
        const tsRaw = puzzleData?.levelDate;
        const parsed = tsRaw ? new Date(tsRaw).getTime() : NaN;
        const ts = isNaN(parsed) ? Date.now() : parsed;

        postTimestampMap[postId] = ts;

        const lbEntries = await redis.zRange(`lb:${postId}`, 0, -1);
        for (const row of lbEntries) {
          usernameSet.add(row.member);
        }
      }

      const usernamesCollected = [...usernameSet];

      // --- SAVE JOB ---
      const job = {
        name: "job-resync-batch-user-profiles",
        usernames: usernamesCollected,
        postIds: postIdsStrings,
        postTagMap,
        postCreatorMap,
        postTimestampMap,

        index: 0,
        total: usernamesCollected.length,
        startedAt: new Date().toISOString(),
        lastRunAt: "...Job not ran yet...",
        completedAt: null,

        processedLastBatch: 25
      };

      await redis.set("job:resyncProfiles", JSON.stringify(job));

      logger.info(`Queued job for ${job.total} users`);

      return c.json({
        showToast: {
          text: `Queued resync for ${job.total} users`
        }
      });

    } catch (err) {
      logger.error(err);
      return c.json({ showToast: { text: "Failed to queue job" } });
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/menu/resync-single-user", async (c) => {
    const logger = await Logger.Create("Menu - Resync Single User");
    logger.traceStart("Menu Action");

    try {
      return c.json({
        showForm: {
          name: "resyncSingleUserForm",
          form: {
            fields: [
              {
                type: "string",
                name: "username",
                label: "Username(s, comma separated)",
                required: true
              }
            ]
          }
        }
      });
    } catch (error) {
      logger.error("Menu action error:", error);
      return c.json({
        showToast: { text: "Failed to open form" }
      });
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/form/resync-single-user", async (c) => {
    const logger = await Logger.Create("Form - Resync Single User");
    logger.traceStart("Form Submit");

    try {
      const values = await c.req.json<any>();

      logger.info("Form POST body:", JSON.stringify(values, null, 2));

      const usernames = values.username
      .split(",")
      .map((u: string) => u.trim())
      .filter(Boolean);

      if (usernames.length === 0) {
        return c.json({
          showToast: { text: "Username(s) is required" }
        }, 400);
      }

      // Optional: block if job already running
      const existing = await redis.get("job:resyncProfiles");
      if (existing) {
        return c.json({
          showToast: { text: "A resync job is already running" }
        });
      }

      // --- Build shared data (same as your batch job) ---
      const postIds = await redis.zRange("levelList", 0, -1);
      const postIdsStrings = postIds.map(p => p.member);


      const postTagMap: Record<string, string> = {};
      const postCreatorMap: Record<string, string> = {};
      const postTimestampMap: Record<string, number> = {};

      for (const entry of postIds) {
        const postId = entry.member;
        const levelID = entry.score;

        const puzzleData = await redis.hGetAll(`puzzle:${levelID}`);
        const levelTag = puzzleData?.levelTag ?? "missing";

        postTagMap[postId] = levelTag;

        postCreatorMap[postId] = puzzleData?.levelCreator ?? "SneakleBot";

        // timestamp
        const tsRaw = puzzleData?.levelDate;
        const parsed = tsRaw ? new Date(tsRaw).getTime() : NaN;
        const ts = isNaN(parsed) ? Date.now() : parsed;

        postTimestampMap[postId] = ts;

        // const lbEntries = await redis.zRange(`lb:${postId}`, 0, -1);
        // for (const row of lbEntries) {
        //   usernameSet.add(row.member);
        // }
      }

      // --- Create SINGLE USER job ---
      const job = {
        name: "job-resync-single-user-profile",
        usernames: usernames,
        postIds: postIdsStrings,
        postTagMap,
        postCreatorMap,
        postTimestampMap,

        index: 0,
        total: usernames.length,

        startedAt: new Date().toISOString(),
        lastRunAt: null,
        type: "single"
      };

      await redis.set("job:resyncProfiles", JSON.stringify(job));

      logger.info(`Queued single-user resync for ${usernames}`);

      return c.json({
        showToast: {
          text: `Queued resync for ${usernames}`
        }
      });

    } catch (error) {
      logger.error("Form submit error:", error);
      return c.json({
        showToast: { text: "Failed to queue resync" }
      }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/menu/resync-created-karma", async (c) => {
    const logger = await Logger.Create("Menu - Resync Created Karma");
    logger.traceStart("Resync Created Karma");

    try {
      const existing = await redis.get("job:resyncCreatedKarma");
      if (existing) {
        return c.json({
          showToast: { text: "A created karma resync job is already running" },
        });
      }

      const creatorsAsc = await redis.zRange("lb:alltime:created:total", 0, -1);
      const usernames = creatorsAsc
        .map((entry) => entry.member)
        .filter((u): u is string => Boolean(u));

      const job = {
        name: "job-resync-created-karma",
        usernames,
        index: 0,
        total: usernames.length,
        startedAt: new Date().toISOString(),
        lastRunAt: "...Job not ran yet...",
        completedAt: null,
      };

      await redis.set("job:resyncCreatedKarma", JSON.stringify(job));

      return c.json({
        showToast: { text: `Queued created karma resync for ${job.total} creators` },
      });
    } catch (error) {
      logger.error("Failed to queue created karma resync", error);
      return c.json({
        showToast: { text: "Failed to queue created karma resync" },
      }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  //

  router.post("/internal/menu/cancel-job", async (c) => {
    const logger = await Logger.Create("Menu - cancelJobForm");
    logger.traceStart("Menu Action");

    try {
      return c.json({
        showForm: {
          name: "cancelJobForm",
          form: {
            fields: [
              {
                type: "string",
                name: "jobName",
                label: "job.name (ex: job-resync-batch-user-profiles)",
                required: true
              }
            ]
          }
        }
      });
    } catch (error) {
      logger.error("Menu action error:", error);
      return c.json({
        showToast: { text: "Failed to open form" }
      });
    } finally {
      logger.traceEnd();
    }
  });

  router.post("/internal/form/cancel-job", async (c) => {
    const logger = await Logger.Create("Form - cancel-job");
    logger.traceStart("Form Submit");

    try {
      const values = await c.req.json<any>();
      const CANCEL_KEY_PREFIX = "job:cancel:";

      logger.info("Form POST body:", JSON.stringify(values, null, 2));

      const jobName = values.jobName;

      if (!jobName) {
        return c.json({
          showToast: { text: "jobName is required" }
        }, 400);
      }

      await redis.set(`${CANCEL_KEY_PREFIX}${jobName}`, "1");
      logger.info(`Set cancel flag for job: ${jobName}`);

      return c.json({
        showToast: {
          text: `cancel job sent for ${jobName}`
        }
      });

    } catch (error) {
      logger.error("Form submit error:", error);
      return c.json({
        showToast: { text: "Failed to cancel job" }
      }, 500);
    } finally {
      logger.traceEnd();
    }
  });


  //old version that failed because lists too long to complete
  /*
  router.post("/internal/menu/resync-user-profiles", async (c) => {
    const logger = await Logger.Create("Menu - Resync Profiles");
    logger.traceStart("Resync Profiles");

    try {

      // ! Using usernamesCollected below now instead
      const usernames = ["FermenterGames", "Alice", "Bob"] //: string[] = await c.req.json<any>()?.usernames ?? [];
      if (!usernames.length) return c.json({ error: "No usernames provided" }, 400);

      // Fetch all post IDs from levelList
      const postIds: string[] = await redis.zRange("levelList", 0, -1);
      logger.info(`Found ${postIds.length} posts.`);
      const postIdsStrings = postIds.map(p => p.member); // now this is an array of strings
      logger.info(`Post IDs strings: ${postIdsStrings.join(", ")}`);

      const postTagMap: Record<string, string> = {};

      const usernameSet = new Set<string>();

      for (const entry of postIds) {
        const postId = entry.member;
        const levelID = entry.score;

        const puzzleData = await redis.hGetAll(`puzzle:${levelID}`);

        const levelTag = puzzleData?.levelTag ?? "missing";

        postTagMap[postId] = levelTag;

        logger.info(`Cached ${postId} -> ${levelTag}`);



        const lbKey = `lb:${postId}`;

        const lbEntries = await redis.zRange(lbKey, 0, -1);

        for (const row of lbEntries) {
          usernameSet.add(row.member);
        }

      }

      const usernamesCollected = [...usernameSet];

      logger.info(`Collected ${usernamesCollected.length} unique usernames from leaderboards`);
      // logger.info(`usernamesCollected: ${usernamesCollected.join("\n")}`);
      // logger.info(`-----`);
      logger.info(usernamesCollected);

      logger.info(`Starting resync for ${usernamesCollected.length} users.`);

      //counters
      let uchecked = 0;
      let uvalid = 0;

      for (const username of usernamesCollected) { //usernames) {
        uchecked++;
        const profileKey = `profile:${username}`;
        const profileRaw = await redis.get(profileKey);

        if (!profileRaw) {
          logger.info(`--- [${uchecked}] - Skipping ${username}: profile does not exist`);
          continue; // skip this user
        }

        logger.info(`--- [${uchecked}] (${uvalid} valid) - User: ${username} - profile exists, try to resync`);

        const {
          totalStartedDaily,
          totalFinishedDaily,
          totalGaveUpDaily,
          totalScoreDaily,
          totalTimeDaily,
          totalGuessesDaily,
          totalHintsDaily,

          totalStartedCommunity,
          totalFinishedCommunity,
          totalGaveUpCommunity,
          totalScoreCommunity,
          totalTimeCommunity,
          totalGuessesCommunity,
          totalHintsCommunity,

        } = await (async () => {
          let totalStartedDaily = 0;
          let totalFinishedDaily = 0;
          let totalGaveUpDaily = 0;
          let totalScoreDaily = 0;
          let totalTimeDaily = 0;
          let totalGuessesDaily = 0;
          let totalHintsDaily = 0;

          let totalStartedCommunity = 0;
          let totalFinishedCommunity = 0;
          let totalGaveUpCommunity = 0;
          let totalScoreCommunity = 0;
          let totalTimeCommunity = 0;
          let totalGuessesCommunity = 0;
          let totalHintsCommunity = 0;


          for (const postId of postIdsStrings) {

            const levelTag = postTagMap[postId] ?? "missing";
            //logger.info(`trying post ${postId} (levelTag = ${levelTag})`);

            const stateRaw = await redis.get(`state:${postId}:${username}`);
            if (!stateRaw) {
              //logger.info(`stateRaw nope on ${postId}`);
              continue;
            } else {
              //logger.info(`stateRaw for ${postId} is ${stateRaw}`);
            }

            let stateJson;
            try { stateJson = JSON.parse(stateRaw); } catch { continue; }

            const status = parseInt(stateJson?.data?.level_status ?? "0", 10);
            const scoreGuesses = parseInt(stateJson?.data?.score_guesses ?? "0", 10);
            const scoreHints = parseInt(stateJson?.data?.score_hints ?? "0", 10);
            const scoreTime = parseInt(stateJson?.data?.score_time ?? "0", 10);
            const scoreCombined = parseInt(stateJson?.data?.score_combined ?? "0", 10);

            //logger.info(`status on post ${postId} is ${status}`);
            if (status === 0) continue; // not started, skip

            // increment counts based on levelTag
            if (levelTag === "daily") {
              if (status === 1 || status === 2) totalStartedDaily += 1;
              else if (status === 3) { totalStartedDaily += 1; totalFinishedDaily += 1; }

              // accumulate stats
              totalScoreDaily += scoreCombined;
              totalTimeDaily += scoreTime;
              totalGuessesDaily += scoreGuesses;
              totalHintsDaily += scoreHints;

            } else if (levelTag === "community") {
              if (status === 1 || status === 2) totalStartedCommunity += 1;
              else if (status === 3) { totalStartedCommunity += 1; totalFinishedCommunity += 1; }

              // accumulate stats
              totalScoreCommunity += scoreCombined;
              totalTimeCommunity += scoreTime;
              totalGuessesCommunity += scoreGuesses;
              totalHintsCommunity += scoreHints;

            } //else {
              // if (status === 1 || status === 2) totalStartedUnlimited += 1;
              // else if (status === 3) { totalStartedUnlimited += 1; totalFinishedUnlimited += 1; }

              // // accumulate stats
              // totalScoreUnlimited += scoreCombined;
              // totalTimeUnlimited += scoreTime;
              // totalGuessesUnlimited += scoreGuesses;
              // totalHintsUnlimited += scoreHints;
            //}
          }

          return {
            totalStartedDaily,
            totalFinishedDaily,
            totalGaveUpDaily,
            totalScoreDaily,
            totalTimeDaily,
            totalGuessesDaily,
            totalHintsDaily,

            totalStartedCommunity,
            totalFinishedCommunity,
            totalGaveUpCommunity,
            totalScoreCommunity,
            totalTimeCommunity,
            totalGuessesCommunity,
            totalHintsCommunity,

          };
        })();

        // Direct Redis update
        const prev = JSON.parse(profileRaw);

        const removedKeys: string[] = [];

        // remove numeric keys accidentally created by ...username
        for (const key of Object.keys(prev)) {
          if (!isNaN(Number(key))) {
            removedKeys.push(key);
            delete prev[key];
          }
        }

        if (removedKeys.length) {
          logger.info(`${username}: removed stray keys ${removedKeys.join(",")}`);
        }


        const prevData = prev.profileData ?? {};

        // ---------- Build new stats ----------
        const newStats = {
          stat_d_total_started: totalStartedDaily,
          stat_d_total_finished: totalFinishedDaily,
          stat_d_total_gaveup: totalGaveUpDaily,
          stat_d_total_score: totalScoreDaily,
          stat_d_total_time: totalTimeDaily,
          stat_d_total_guesses: totalGuessesDaily,
          stat_d_total_hints: totalHintsDaily,

          stat_c_total_started: totalStartedCommunity,
          stat_c_total_finished: totalFinishedCommunity,
          stat_c_total_gaveup: totalGaveUpCommunity,
          stat_c_total_score: totalScoreCommunity,
          stat_c_total_time: totalTimeCommunity,
          stat_c_total_guesses: totalGuessesCommunity,
          stat_c_total_hints: totalHintsCommunity,

        };

        // ---------- Compute stat diffs ----------
        const diffs: string[] = [];

        for (const [key, newVal] of Object.entries(newStats)) {

          const prevVal = parseInt(prevData[key] ?? "0", 10);

          if (prevVal !== newVal) {

            diffs.push(`${key}: ${prevVal} -> ${newVal}`);

            if (newVal < prevVal) {
              logger.info(`${username} stat decreased: ${key} ${prevVal} -> ${newVal}`);
            }

          }
        }

        // ---------- Log result ----------
        if (diffs.length) {
          logger.info(`${username} stat changes:\n${diffs.join("\n")}`);
        } else {
          logger.info(`${username}: no stat changes`);
        }

        // ---------- Build next profile ----------
        const next = {
          ...prev,
          profileData: {
            ...prevData,
            ...newStats,
          },
          username,
          updatedBy: username,
          updatedAt: new Date().toISOString(),
        };


        // ---------- Save!!! ----------
        await redis.set(profileKey, JSON.stringify(next));   

        // ------- Log newly saved profile
        //const nextStr = JSON.stringify(next);
        //logger.info(nextStr);

      }

      return c.json({
        showToast: {
          text: `Resynced ${usernamesCollected.length} users`
        }
      });
    } catch (error) {
      logger.error("Resync Profiles error:", error);
      return c.json({
        showToast: {
          text: `Resynced failed!`
        }
      });
    } finally {
      logger.traceEnd();
    }
  });
  */


  // ========== Add Puzzle Form (handled below) ==========
  router.post("/internal/menu/add-puzzle-to-daily-queue", async (c) => {
    const logger = await Logger.Create("Menu - Add Puzzle");
    logger.traceStart("Menu Action");

    try {
      return c.json({
        showForm: {
          name: "addPuzzleForm",
          form: {
            fields: [
              { type: "string", name: "levelName", label: "Level Name", required: true },
              { type: "string", name: "gameData", label: "Game Data", required: true },
              { type: "string", name: "levelTag", label: "Level Tag", required: false, defaultValue: "daily" },
              { type: "string", name: "levelCreator", label: "Level Creator", required: false, defaultValue: "SneakleBot" },
              { type: "string", name: "nonStandard", label: "nonStandard", required: false, defaultValue: "0" },
              { type: "string", name: "levelDate", label: "Level Date", required: false, defaultValue: new Date().toISOString() },
            ],
          },
        },
      });
    } catch (error) {
      logger.error("Menu action error:", error);
      return c.json({
        showToast: { text: "Failed to open form" },
      });
    } finally {
      logger.traceEnd();
    }
  });


  // ========== Handle Add Puzzle Form ==========
  router.post("/internal/form/add-puzzle-to-daily-queue", async (c) => {
    const logger = await Logger.Create("Form - Add Puzzle");
    logger.traceStart("Form Submit");

    try {
      const values = await c.req.json<any>();

      logger.info("Form POST body:", JSON.stringify(values, null, 2));

      if (!values?.levelName || !values?.gameData) {
        return c.json({
          showToast: {
            text: "Missing required fields: levelName, gameData"
          }
        }, 400);
      }

      const puzzle = {
        queueId: crypto.randomUUID(),
        levelName: values.levelName,
        gameData: values.gameData,
        levelTag: values.levelTag || "daily",
        levelCreator: values.levelCreator || "SneakleBot",
        nonStandard: values.nonStandard || "0",
        levelDate: values.levelDate || new Date().toISOString(),
        addedAt: Date.now(),
      };

      await enqueuePuzzle(puzzle);

      const queue = await getQueue();

      return c.json({
        showToast: {
          text: `Puzzle "${puzzle.levelName}" added to queue (length ${queue.length})`
        }
      });
    } catch (error) {
      logger.error("Form submit error:", error);
      return c.json({ error: "Failed to add puzzle to queue" }, 500);
    } finally {
      logger.traceEnd();
    }
  });


  // ========== toggle-puzzle-posting ==========
  router.post("/internal/menu/toggle-puzzle-posting", async (c) => {
    const logger = await Logger.Create("Menu - Toggle Puzzle Posting");
    logger.traceStart("Menu Action");

    try {
      const newState = await togglePostingEnabled();

      return c.json({
        showToast: {
          text: `Puzzle auto-posting ${newState ? "enabled" : "paused"}`
        }
      });
    } catch (err) {
      logger.error("Toggle posting failed", err);
      return c.json({ error: "Failed to toggle posting" }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Show Queue Length ==========
  router.post("/internal/menu/puzzle-queue-status", async (c) => {
    const logger = await Logger.Create("Menu - Queue Status");
    logger.traceStart("Menu Action");

    try {
      const queue = await getQueue();
      return c.json({
        showToast: {
          text: `Puzzle queue length: ${queue.length}`
        },
      });
    } catch (error) {
      logger.error("Queue status error:", error);
      return c.json({
        showToast: { text: "Failed to fetch queue status" },
      });
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Preview Next Puzzle ==========
  router.post("/internal/menu/puzzle-preview-next", async (c) => {
    const logger = await Logger.Create("Menu - Preview Next Puzzle");
    logger.traceStart("Menu Action");

    try {
      const queue = await getQueue();
      const nextPuzzle = queue[0] ?? null;

      if (!nextPuzzle) {
        return c.json({
          showToast: { text: "Queue is empty"},
        });
      }

      return c.json({
        showToast: { text: `Next puzzle: "${nextPuzzle.levelName}"`},
      });
    } catch (error) {
      logger.error("Preview next puzzle error:", error);
      return c.json({
        showToast: { text: "Failed to preview next puzzle" },
      });
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Clear Queue (Mod Only) ==========
  router.post("/internal/menu/puzzle-clear-queue", async (c) => {
    const logger = await Logger.Create("Menu - Clear Queue");
    logger.traceStart("Menu Action");

    try {
      await clearQueue();
      return c.json({
        showToast: { text: "Puzzle queue cleared"},
      });
    } catch (error) {
      logger.error("Clear queue error:", error);
      return c.json({
        showToast: { text: "Failed to clear puzzle queue" },
      });
    } finally {
      logger.traceEnd();
    }
  });

  // ========== RESET Level/Daily lists/counts (Mod Only) ==========
  router.post("/internal/menu/reset-lists", async (c) => {
    const logger = await Logger.Create("Menu - Reset Lists");
    logger.traceStart("Menu Action");

    try {
      //reset counts and lists
      await redis.del("levelCount");
      await redis.del("dailyCount");
      await redis.del("dailyList");
      await redis.del("levelList");
      console.log("Reset daily/level counts and lists complete");

      return c.json({
        showToast: { text: "Reset daily/level counts and lists complete"},
      });
    } catch (error) {
      logger.error("Reset Lists error:", error);
      return c.json({
        showToast: { text: "Failed to Reset Lists" },
      });
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Post Next Puzzle Now ==========
  router.post("/internal/menu/puzzle-post-now", async (c) => {
    const logger = await Logger.Create("Menu - Post Next Puzzle");
    logger.traceStart("Menu Action");

    try {
      // Optional: respect posting toggle

      // if (!(await isPostingEnabled())) {
      //   return c.json({
      //     showToast: { text: "Auto-posting is currently paused"},
      //   });
      //   return;
      // }

      // Dequeue next puzzle
      const puzzle = await dequeuePuzzle();
      if (!puzzle) {
        return c.json({
          showToast: { text: "Queue is empty. Nothing to post."},
        });
      }

      // Post puzzle using the same function as scheduled job
      const { createGamePostFromPuzzle } = await import("../actions/createGamePost");
      const post = await createGamePostFromPuzzle(puzzle);

      return c.json({
        showToast: { text: `Puzzle "${puzzle.levelName}" posted successfully! Post ID: ${post.id}`},
      });
    } catch (error) {
      logger.error("Post next puzzle error:", error);
      return c.json({
        showToast: { text: "Failed to post next puzzle" },
      });
    } finally {
      logger.traceEnd();
    }
  });


  // ========== Import Puzzles JSON ==========
  router.post("/internal/menu/puzzle-import-json", async (c) => {
    const logger = await Logger.Create("Menu - Import Puzzles JSON");
    logger.traceStart("Menu Action");

    try {
      // Step 1: Show form to paste JSON
      return c.json({
        showForm: {
          name: "importPuzzlesForm",
          form: {
            fields: [
              {
                type: "string",
                name: "json",
                label: "Paste JSON array of puzzles",
                multiline: true,
                required: true,
                placeholder: '[{"levelName":"Puzzle 1","gameData":"..."}]'
              }
            ]
          }
        }
      });
    } catch (err) {
      logger.error("Failed to show import form", err);
      return c.json({ error: "Failed to open import form" }, 500);
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Handle form submission ==========
  router.post("/internal/form/puzzle-import-json", async (c) => {
    const logger = await Logger.Create("Form - Import Puzzles JSON");
    logger.traceStart("Form Submission");

    try {
      const values = await c.req.json<any>();
      if (!values?.json) {
        return c.json({ error: "Missing JSON input" }, 400);
      }

      let puzzles: any[];
      try {
        puzzles = JSON.parse(values.json);
        if (!Array.isArray(puzzles)) throw new Error("JSON is not an array");
      } catch (err) {
        return c.json({ error: "Invalid JSON: " + (err instanceof Error ? err.message : String(err)) }, 400);
      }

      // Validate each puzzle and enqueue
      let added = 0;
      for (const p of puzzles) {
        if (p.levelName && p.gameData) {
          await enqueuePuzzle({
            queueId: crypto.randomUUID(),
            levelName: p.levelName,
            gameData: p.gameData,
            levelTag: p.levelTag || "daily",
            levelCreator: p.levelCreator || "SneakleBot",
            levelDate: p.levelDate || new Date().toISOString(),
            addedAt: Date.now()
          });
          added++;
        }
      }

      return c.json({
        showToast: {
          text: `Imported ${added} puzzles into the queue`
        }
      });
    } catch (err) {
      logger.error("Failed to import puzzles", err);
      return c.json({ error: "Failed to import puzzles" }, 500);
    } finally {
      logger.traceEnd();
    }
  });


  // ========== Manage Puzzle Queue ==========
  router.post("/internal/menu/puzzle-manage-queue", async (c) => {
    const logger = await Logger.Create("Menu - Manage Puzzle Queue");
    logger.traceStart("Menu Action");

    try {

      // const fixqueue = (await getQueue()).map(p =>
      //   p.queueId ? p : { ...p, queueId: crypto.randomUUID() }
      // );

      // await replaceQueue(fixqueue);

      const queue = await getQueue();

      // if (queue.length === 0) {
      //   return c.json({
      //     showToast: { text: "Queue is empty"}
      //   });
      //   return;
      // }

      const postingEnabled = await isPostingEnabled();

      const nextRun = postingEnabled
        ? getNextDailyRun(0)
        : null;

      const currDailyId = await getCurrentDailyCount(); 

      const nextDailyId = Number(currDailyId) + 1; //getNextDailyId();

      logger.info("nextDailyId: ", nextDailyId);

      const today = new Date();

      


      //add summary to top of manager
      const summaryGroupField = {
        type: 'group',
        name: "queueSummary",
        label:
          `📊 Queue status --\n\n` +
          `• Length: ${queue.length}\n` +
          `• Auto-posting: ${postingEnabled ? "ENABLED" : "PAUSED"}\n` +
          `• Next post: ${nextRun ? nextRun.toLocaleString() : "-"}\n` +
          `• Next Daily ID: ${nextDailyId}\n`,
        fields: [
        ],
      };


      // Build form with one Group per puzzle
      const formFields = queue.map((puzzle, index) => {

        const id = puzzle.queueId; // ?? Date.now() + index;

        const projectedDailyId = nextDailyId + index;
        const projectedDate = new Date(today);
        projectedDate.setDate(today.getDate() + index);

        const projectedDateStr = projectedDate.toLocaleDateString("en-US", {
          weekday: "short",
          month: "short",
          day: "numeric",
          year: "numeric",
        });

        return {
          type: "group",
          name: `puzzleGroup_${id}`,
          label: `Queued Puzzle #${index + 1} - Scheduled dailyID: ${String(projectedDailyId)} - Scheduled Date: ${projectedDateStr} - Imported Name: ${puzzle.levelName}`,
          fields: [
            // {
            //   type: "string",
            //   name: `levelName_${id}`,
            //   label: "Level Name",
            //   defaultValue: puzzle.levelName,
            //   disabled: true,
            // },
            {
              type: "string",
              name: `gameData_${id}`,
              label: "Game Data",
              defaultValue: puzzle.gameData,
              placeholder: "Paste or edit game data here"
            },
            {
              type: "boolean",
              name: `delete_${id}`,
              label: "Delete this puzzle?"
            },
            {
              type: "number",
              name: `position_${id}`,
              label: "New Position",
              defaultValue: index + 1,
              min: 1,
              max: queue.length
            }
          ]
        };
      });

      //console.log(JSON.stringify(formFields));

      return c.json({
        showForm: {
          name: "managePuzzleQueueForm",
          form: {
            fields: [
              summaryGroupField,
              ...formFields
            ]
          }
        }
      });
    } catch (err) {
      logger.error("Failed to show Manage Queue form", err);
      return c.json({ showToast: { text: "Failed to open queue management form" } });
    } finally {
      logger.traceEnd();
    }
  });

  // ========== Handle Manage Queue Form Submission ==========
  // POST handler for form submission
  router.post("/internal/form/puzzle-manage-queue", async (c) => {
    const logger = await Logger.Create("Menu - Manage Puzzle Queue Submission");
    logger.traceStart("Form Submit");

    try {

      await redis.del("dailyCount");
      await redis.del("levelCount");

      const queue = await getQueue();
      const values = await c.req.json<any>();

      if (!queue.length) {
        return c.json({
          showToast: { text: "Queue is already empty" },
        });
      }

      const working: any[] = [];

      for (let i = 0; i < queue.length; i++) {
        const puzzle = queue[i];
        const id = puzzle.queueId;

        if (!id) continue;

        // Delete?
        if (values[`delete_${id}`] === true) continue;

        // Edited game data (fallback to existing)
        const editedGameData = values[`gameData_${id}`];
        const gameData =
          typeof editedGameData === "string" && editedGameData.trim().length
            ? editedGameData.trim()
            : puzzle.gameData;

        if (!gameData.startsWith("loadBoard=")) {
          return c.json({
            showToast: { text: "Invalid game data format" },
          });
        }

        // Position hint (forgiving)
        const rawPosition = Number(values[`position_${id}`]);

        working.push({
          ...puzzle,
          gameData,
          __sortKey: Number.isFinite(rawPosition)
            ? rawPosition
            : i + 1,
        });
      }

      // Sort by intent
      working.sort((a, b) => a.__sortKey - b.__sortKey);

      // Normalize to 1..n
      const finalQueue = working.map((puzzle, index) => {
        const { __sortKey, ...rest } = puzzle;
        return {
          ...rest,
          position: index + 1, // optional metadata
        };
      });

      // Allow delete-all
      if (!finalQueue.length) {
        await replaceQueue([]);
        return c.json({
          showToast: { text: "Queue cleared - all puzzles deleted" },
        });
      }

      await replaceQueue(finalQueue);

      return c.json({
        showToast: {
          text: `Queue updated (${finalQueue.length} puzzles saved)`,
        },
      });
    } catch (err) {
      logger.error("Failed to update puzzle queue", err);
      return c.json({
        showToast: { text: "Failed to update queue" },
      });
    } finally {
      logger.traceEnd();
    }
  });


  // ========== Export Puzzle Queue as JSON ==========
  router.post("/internal/menu/puzzle-export-queue", async (c) => {
    const logger = await Logger.Create("Menu - Export Puzzle Queue");
    logger.traceStart("Menu Action");

    try {
      const queue = await getQueue();

      if (!queue.length) {
        return c.json({
          showToast: { text: "Queue is empty" },
        });
      }

      const json = JSON.stringify(queue, null, 2);

      return c.json({
        showForm: {
          name: "exportPuzzleQueueForm",
          form: {
            fields: [
              {
                type: "paragraph",
                name: "queueJson",
                label: "Puzzle Queue (copy & save as .json)",
                defaultValue: json,
                readonly: true,
              },
            ],
          },
        },
      });
    } catch (err) {
      logger.error("Export queue failed", err);
      return c.json({
        showToast: { text: "Failed to export queue" },
      });
    } finally {
      logger.traceEnd();
    }
  });
  

  ////////////////

  router.post("/internal/menu/manage-postdata", async (c) => {
    const logger = await Logger.Create("Menu - Edit PostData");

    try {
      const postId = context.postId;
      if (!postId) {
        return c.json({ showToast: { text: "No post context" }});
      }

      const data = context.postData || {};

      return c.json({
        showForm: {
          name: "managePostDataForm",
          form: {
            fields: [
              {
                type: "string",
                name: "postId",
                label: "postId - DON'T CHANGE",
                defaultValue: context.postId,
                hidden: true
              },
              {
                type: "string",
                name: "levelName",
                label: "Level Name",
                defaultValue: data.levelName ?? ""
              },
              {
                type: "string",
                name: "levelDate",
                label: "Level Date (ISO // {year}-{month}-{day}T00:00:00.000Z)",
                defaultValue: data.levelDate ?? ""
              },
              {
                type: "string",
                name: "levelTag",
                label: "Level Tag",
                defaultValue: data.levelTag ?? ""
              },
              {
                type: "string",
                name: "gameData",
                label: "Game Data",
                defaultValue: data.gameData ?? ""
              },
              {
                type: "number",
                name: "dailyID",
                label: "Daily ID",
                defaultValue: Number(data.dailyID ?? -1)
              },
              {
                type: "string",
                name: "nonStandard",
                label: "nonStandard",
                defaultValue: data.nonStandard ?? ""
              }
            ]
          }
        }
      });

    } catch (err) {
      logger.error("Open editor failed", err);
      return c.json({ showToast: { text: "Failed opening editor" }});
    }
  });


  //

  router.post("/internal/form/manage-postdata", async (c) => {
    const logger = await Logger.Create("Form - Manage PostData");

    try {
      const { postId } = await c.req.json<any>();
      if (!postId) {
        return c.json({ showToast: { text: "No post context" }});
      }

      const values = await c.req.json<any>();

      if (!values.gameData?.trim()) {
        return c.json({
          showToast: { text: "Game Data cannot be empty" }
        });
      }

      const post = await reddit.getPostById(postId);
      if (!post) {
        return c.json({ showToast: { text: "Post not found" }});
      }

      const existing = await post.getPostData();

      //const [month, day, year] = values.levelDate.split("-");
      //const levelDateFormatted = `${year}-${month}-${day}T00:00:00.000Z`;

      const updated = {
        ...(existing || {}),
        levelName: values.levelName,
        levelDate: values.levelDate,
        levelTag: values.levelTag,
        gameData: values.gameData,
        dailyID: values.dailyID,
        nonStandard: values.nonStandard,
        lastUpdatedAt: new Date().toISOString()
      };

      logger.info("updating post", updated);

      await post.setPostData(updated);

      return c.json({ showToast: { text: "Post updated" }});

    } catch (err) {
      logger.error("Save failed", err);
      return c.json({ showToast: { text: "Save failed" }});
    }
  });



  ////////////////////////////

  router.post("/internal/menu/manage-dailylist", async (c) => {
    const logger = await Logger.Create("Menu - Manage DailyList");

    try {
      const entries = await redis.zRange("dailyList", 0, -1);

      if (!entries.length) {
        return c.json({ showToast: { text: "Daily list is empty" }});
      }

      const fields = entries.map((e, index) => ({
        type: "group",
        name: `daily_${index}`,
        label: `Daily #${index}`,
        fields: [
          {
            type: "string",
            name: `postId_${index}`,
            label: "Post ID",
            defaultValue: e.member,
            readonly: true
          },
          {
            type: "number",
            name: `score_${index}`,
            label: "dailyID (score)",
            defaultValue: Number(e.score),
            min: 0
          },
          {
            type: "boolean",
            name: `delete_${index}`,
            label: "Delete entry?"
          }
        ]
      }));

      return c.json({
        showForm: {
          name: "manageDailyListForm",
          form: { fields }
        }
      });

    } catch (err) {
      logger.error("Failed opening daily list manager", err);
      return c.json({ showToast: { text: "Failed to open manager" }});
    }
  });

  //

  //for rearranging and deleting dailyList lb entries
  router.post("/internal/form/manage-dailylist", async (c) => {
    const logger = await Logger.Create("Form - Manage DailyList");

    try {
      const values = await c.req.json<any>();
      const existing = await redis.zRange("dailyList", 0, -1);

      const updated: { member: string; score: number }[] = [];

      for (let i = 0; i < existing.length; i++) {

        if (values[`delete_${i}`]) continue;

        const member = values[`postId_${i}`];
        const score =
          Number(values[`score_${i}`]) ??
          updated.length;

        updated.push({ member, score });
      }

      // Sort by score
      updated.sort((a, b) => a.score - b.score);

      // Auto-fix to 0..n
      const normalized = updated.map((e, i) => ({
        member: e.member,
        score: i
      }));

      // Replace sorted set
      await redis.del("dailyList");

      for (const e of normalized) {
        await redis.zAdd("dailyList", e);
      }

      return c.json({
        showToast: {
          text: `Daily list updated (${normalized.length} entries)`
        }
      });

    } catch (err) {
      logger.error("Failed updating daily list", err);
      return c.json({ showToast: { text: "Update failed" }});
    }
  });


  //

  //for moving preexisting puzzles from basic levelList lb redis to more robust puzzle:levelList which mirrors all relavant postData
  router.post("/internal/menu/migrate-puzzle-metadata", async (c) => {

    const logger = await Logger.Create("Menu - migrate-puzzle-metadata");

    try {

      const results = await redis.zRange("levelList", 0, -1);

      for (const item of results) {

        // item may be a string or object
        const postId = typeof item === "string" ? item : item.member;

        //delete old postId keys - only do once
        // if (postId) {
        //   await redis.del(`puzzle:${postId}`);
        // }

        const levelID =
          typeof item === "string"
            ? item
            : String(item.score);

        // skip invalid entries early
        if (!postId || !levelID) {
          logger.info(`Skipping invalid entry: ${JSON.stringify(item)}`);
          continue;
        }

        try {

          const post = await reddit.getPostById(postId as `t3_${string}`);
          //const post = await reddit.getPostById(postId as `t3_${string}`);
          const postData = await post.getPostData();

          if (!postData) continue;

          logger.info("RAW POSTDATA:");
          logger.info(JSON.stringify(postData));

          await redis.hSet(`puzzle:${levelID}`, {
            postId: String(postId),
            levelName: String(postData.levelName ?? ""),
            levelTag: String(postData.levelTag ?? ""),
            levelID: String(levelID ?? ""),
            levelDate: String(postData.levelDate ?? ""),
            levelCreator: String(postData.levelCreator ?? ""),
            gameData: String(postData.gameData ?? ""),
            dailyID: String(postData.dailyID ?? ""),
            nonStandard: String(postData.nonStandard ?? "0"),
          });

          // new mapping for archive
          await redis.set(`post:${postId}:levelID`, String(postData.levelID ?? ""));

          const puzzDebug = await redis.hGetAll(`puzzle:${levelID}`);
          logger.info("AFTER WRITE: " + JSON.stringify(puzzDebug));

          logger.info(`Migrated level ${levelID}`);


        } catch (err) {
          console.log("Failed processing post:", postId, err);
        }
      }

      // const test = await redis.get(`post:t3_1s6kuto:levelID`);
      // console.log("test output:"); // should print "67"
      // console.log(test); // should print "67"

      return c.json({
        showToast: {
          text: "migrate-puzzle-metadata complete"
        }
      });

    } catch (err) {

      console.error("Migration failed:", err);

      return c.json({ status: "error" }, 500);

    }
  });




  // ========== debug-puzzles ==========
  //to log detailed list of puzzle:levelID
  router.post("/internal/menu/debug-puzzles-redis", async (c) => {
    const logger = await Logger.Create("Menu - debug-puzzles-redis");
    logger.traceStart("Menu Action");

    try {
      const results = await redis.zRange("levelList", 0, -1);

      logger.info("LEVEL LIST RAW:");
      logger.info(JSON.stringify(results));

      const ids = results.map(item =>
        typeof item === "string" ? item : item.score //use levelID which is score
      );

      const puzzles = await Promise.all(
        ids.map(id => redis.hGetAll(`puzzle:${id}`))
      );

      logger.info("debug-puzzles-redis:::")
      logger.info("COUNT: " + puzzles.length);

      puzzles.forEach((puzzle) => {
        logger.info(`Puzzle ${puzzle.levelID}: ${JSON.stringify(puzzle)}`);
      });


      return c.json({
        showToast: {
          text: `debug-puzzles-redis complete?`
        },
      });
    } catch (error) {
      logger.error("debug-puzzles-redis error:", error);
      return c.json({
        showToast: { text: "Failed to debug-puzzles" },
      });
    } finally {
      logger.traceEnd();
    }
  });







};
