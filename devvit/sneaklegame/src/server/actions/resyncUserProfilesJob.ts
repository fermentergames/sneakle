import { Hono } from "hono";
import { Logger } from "../utils/Logger";
import {
  redis
} from "@devvit/web/server";
// import { dequeuePuzzle, isPostingEnabled } from "../utils/puzzleQueueHelpers";
// import { createGamePostFromPuzzle } from "../actions/createGamePost";

const CANCEL_KEY_PREFIX = "job:cancel:";

export const resyncUserProfilesJob = (router: Hono): void => {
  router.post("/internal/scheduler/resync-user-profiles", async (c) => {
    const logger = await Logger.Create("Scheduler - Resync Profiles");

    try {
      const raw = await redis.get("job:resyncProfiles");
      if (!raw) {
        //logger.info("No resyncProfiles job found");
        return c.json({ ok: true });
      }

      const job = JSON.parse(raw);

      const BATCH_SIZE = 50;
      let resetUnlimited = true;
      // Level status macros
      const LEVEL_STATUS_NotStarted = 0;
      const LEVEL_STATUS_Started = 1;
      const LEVEL_STATUS_GaveUp = 2;
      const LEVEL_STATUS_Complete = 3;

      let jobCanceled = false;

      const start = job.index;
      const end = Math.min(start + BATCH_SIZE, job.total);

      logger.info(`Processing users ${start} → ${end}`);

      const getPostPlayersTotal = async (postId: string): Promise<number> => {
        try {
          const levelID = await redis.get(`post:${postId}:levelID`);
          if (levelID) {
            const puzzleData = await redis.hGetAll(`puzzle:${levelID}`);
            if (puzzleData && Object.keys(puzzleData).length > 0 && puzzleData.totalPlayers !== undefined) {
              return Number(puzzleData.totalPlayers ?? "0") || 0;
            }
          }
        } catch (_e) {
          // fall through to leaderboard cardinality fallback
        }

        try {
          return Number((await redis.zCard(`lb:${postId}`)) ?? 0) || 0;
        } catch (_e) {
          return 0;
        }
      };

      const normalizeUsername = (value: unknown): string => String(value ?? "").trim().toLowerCase();

      for (let i = start; i < end; i++) {

        // Cancel if job.name is missing or cancel flag is set
        if (!job.name) {
          logger.warn(`Job missing name at index ${i}, cancelling.`);
          jobCanceled = true;
          break;
        }

        // Check for cancel flag
        const cancelFlag = await redis.get(`${CANCEL_KEY_PREFIX}${job.name}`);

        if (cancelFlag === "1") {
          // Cancel if the flag is explicitly set to "1", null is fine
          logger.info(`Job ${job.name} canceled at user index ${i}`);
          jobCanceled = true;
          // Optionally clear the flag
          await redis.del(`${CANCEL_KEY_PREFIX}${job.name}`);
          break; // stop processing
        }

        const username = job.usernames[i];

        // TEMPORARY MIGRATION CLEANUP:
        // Remove legacy per-user keys now replaced by profile.profileData (created_total / created_ids).
        // Safe to delete this block after resync has run across all users in production.
        const legacyPuzzleCountKey = `user:${username}:puzzleCount`;
        const legacyPuzzlesKey = `user:${username}:puzzles`;
        const [removedPuzzleCount, removedPuzzles] = await Promise.all([
          redis.del(legacyPuzzleCountKey),
          redis.del(legacyPuzzlesKey),
        ]);

        if ((Number(removedPuzzleCount) || 0) > 0 || (Number(removedPuzzles) || 0) > 0) {
          logger.info(
            `${username}: cleaned legacy keys (${legacyPuzzleCountKey}, ${legacyPuzzlesKey})`,
          );
        }

        //// TEMPORARY MIGRATION CLEANUP DONE

        const profileKey = `profile:${username}`;
        const profileRaw = await redis.get(profileKey);

        if (!profileRaw) {
          logger.info(`[${i}] Skipping ${username}, no profile exists`);
          continue;
        }

        //

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

          totalStartedUnlimited,
          totalFinishedUnlimited,
          totalGaveUpUnlimited,
          totalScoreUnlimited,
          totalTimeUnlimited,
          totalGuessesUnlimited,
          totalHintsUnlimited,

          createdPostIds,

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

          let totalStartedUnlimited = 0;
          let totalFinishedUnlimited = 0;
          let totalGaveUpUnlimited = 0;
          let totalScoreUnlimited = 0;
          let totalTimeUnlimited = 0;
          let totalGuessesUnlimited = 0;
          let totalHintsUnlimited = 0;

          const createdPostIds: string[] = [];


          for (const postId of job.postIds) {

            const levelTag = job.postTagMap[postId] ?? "missing";
            //logger.info(`trying post ${postId} (levelTag = ${levelTag})`);

            const levelCreator = job.postCreatorMap[postId];
            if (normalizeUsername(levelCreator) === normalizeUsername(username)) {
              createdPostIds.push(postId);
              logger.info(`${username} created ${postId}`);
            }

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
              if (status === LEVEL_STATUS_Started || status === LEVEL_STATUS_GaveUp) totalStartedDaily += 1;
              else if (status === LEVEL_STATUS_Complete) { totalStartedDaily += 1; totalFinishedDaily += 1; }

              if (status === LEVEL_STATUS_GaveUp) {
                totalGaveUpDaily += 1;
              }

              // accumulate stats
              totalScoreDaily += scoreCombined;
              totalTimeDaily += scoreTime;
              totalGuessesDaily += scoreGuesses;
              totalHintsDaily += scoreHints;
  

            } else if (levelTag === "community") {
              if (status === LEVEL_STATUS_Started || status === LEVEL_STATUS_GaveUp) totalStartedCommunity += 1;
              else if (status === LEVEL_STATUS_Complete) { totalStartedCommunity += 1; totalFinishedCommunity += 1; }

              if (status === LEVEL_STATUS_GaveUp) {
                totalGaveUpCommunity += 1;
              }

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

            totalStartedUnlimited,
            totalFinishedUnlimited,
            totalGaveUpUnlimited,
            totalScoreUnlimited,
            totalTimeUnlimited,
            totalGuessesUnlimited,
            totalHintsUnlimited,

            createdPostIds,

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

        let newStats = {};

        // if (Number(prevData.stat_c_total_started ?? 0) <= 0) {
        //   resetUnlimited = true;
        // }

        if (!resetUnlimited) { //send everything except for ...Unlimited stats

          // totalStartedUnlimited   = prevData?.stat_u_total_started ?? "0";
          // totalFinishedUnlimited  = prevData?.stat_u_total_finished ?? "0";
          // totalGaveUpUnlimited    = prevData?.stat_u_total_gaveup ?? "0";
          // totalScoreUnlimited     = prevData?.stat_u_total_score ?? "0";
          // totalTimeUnlimited      = prevData?.stat_u_total_time ?? "0";
          // totalGuessesUnlimited   = prevData?.stat_u_total_guesses ?? "0";
          // totalHintsUnlimited     = prevData?.stat_u_total_hints ?? "0";

          // ---------- Build new stats ----------
          newStats = {
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

        } else { //do reset unlimited stats to 0, set above, so send everything including ...Unlimited stats

          // ---------- Build new stats ----------
          newStats = {
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

            stat_u_total_started: totalStartedUnlimited,
            stat_u_total_finished: totalFinishedUnlimited,
            stat_u_total_gaveup: totalGaveUpUnlimited,
            stat_u_total_score: totalScoreUnlimited,
            stat_u_total_time: totalTimeUnlimited,
            stat_u_total_guesses: totalGuessesUnlimited,
            stat_u_total_hints: totalHintsUnlimited,

          };

        }

        

        // ---------- Compute stat diffs ----------
        const diffs: string[] = [];

        for (const [key, newVal] of Object.entries(newStats)) {

          const prevVal = parseInt(prevData[key] ?? "0", 10);

          if (prevVal !== newVal) {

            diffs.push(`${key}: ${prevVal} → ${newVal}`);

            if (newVal < prevVal) {
              logger.info(`${username} stat decreased: ${key} ${prevVal} → ${newVal}`);
            }

          }
        }

        // ---------- Log result ----------
        if (diffs.length) {
          logger.info(`${username} stat changes:\n${diffs.join("\n")}`);
        } else {
          logger.info(`${username}: no stat changes`);
        }
        //
        const created_total = createdPostIds.length;
        const created_ids = createdPostIds.length > 0 ? createdPostIds.join(",") : "-1";

        // Compute created_players by summing each created puzzle's totalPlayers cache.
        // Fallback to per-puzzle leaderboard size if cache is missing.
        let created_players = 0;
        for (const postId of createdPostIds) {
          try {
            const count = await getPostPlayersTotal(postId);
            created_players += Number(count ?? 0);
          } catch (_e) { /* ignore per-post errors */ }
        }


        // ---------- Build next profile ----------
        const next = {
          ...prev,
          profileData: {
            ...prevData,
            ...newStats,
            created_total,
            created_ids,
            created_players,
          },
          username,
          updatedBy: username,
          updatedAt: new Date().toISOString(),
        };


        // ---------- Save!!! ----------
        await redis.set(profileKey, JSON.stringify(next));

        // Sync created leaderboard sorted sets (bypassed saveUserProfile, so update directly)
        await redis.zAdd("lb:alltime:created:total",   { score: created_total,   member: username });
        await redis.zAdd("lb:alltime:created:players", { score: created_players, member: username });

        logger.info(`[${i}] Processed ${username}`);

      }

      // --- update progress ---
      job.index = end;
      job.lastRunAt = new Date().toISOString();
      job.processedLastBatch = end - start;

      if ((job.index >= job.total) || (jobCanceled === true)) {
        job.completedAt = new Date().toISOString();
        logger.info("Job complete!");
        logger.info(`Job JSON: ${JSON.stringify(job)}`);
        await redis.del("job:resyncProfiles");
      } else {
        await redis.set("job:resyncProfiles", JSON.stringify(job));
        logger.info(`Progress saved: ${job.index}/${job.total}`);
        logger.info(`Job JSON: ${JSON.stringify(job)}`);
      }

      return c.json({
        showToast: { text: `Job Progress: ${job.index}/${job.total}`}
      });

    } catch (err) {
      logger.error(err);
      return c.json({ error: "Job failed" }, 500);
    }
  });
};
