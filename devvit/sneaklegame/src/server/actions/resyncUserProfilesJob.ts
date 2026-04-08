import { Router } from "express";
import { Logger } from "../utils/Logger";
import {
  redis
} from "@devvit/web/server";
// import { dequeuePuzzle, isPostingEnabled } from "../utils/puzzleQueueHelpers";
// import { createGamePostFromPuzzle } from "../actions/createGamePost";

const CANCEL_KEY_PREFIX = "job:cancel:";

export const resyncUserProfilesJob = (router: Router): void => {
  router.post("/internal/scheduler/resync-user-profiles", async (req, res) => {
    const logger = await Logger.Create("Scheduler - Resync Profiles");

    try {
      const raw = await redis.get("job:resyncProfiles");
      if (!raw) {
        //logger.info("No resyncProfiles job found");
        return res.json({ ok: true });
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
            if (levelCreator === username) {
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


        // ---------- Rebuild created puzzles ----------
        const puzzleKey = `user:${username}:puzzles`;

        // Clear old data (important for resync)
        await redis.del(puzzleKey);

        if (createdPostIds.length > 0) {
          const now = Date.now();

          // logger.info(`DEBUG createdPostIds sample: ${JSON.stringify(createdPostIds.slice(0, 5), null, 2)}`);
          // logger.info(`DEBUG timestampMap sample: ${JSON.stringify(
          //   Object.entries(job.postTimestampMap || {}).slice(0, 5),
          //   null,
          //   2
          // )}`);

          // createdPostIds.forEach(postId => {
          //   if (!postId) logger.error(`❌ postId undefined in createdPostIds`);
          //   else if (!(postId in job.postTimestampMap)) {
          //     logger.warn(`⚠️ postId ${postId} missing in postTimestampMap`);
          //   }
          // });

          const zEntries: { member: string; score: number }[] = [];

          for (const postId of createdPostIds) {

            // ✅ ensure valid string
            if (typeof postId !== "string" || postId.length === 0) {
              logger.error(`❌ Invalid postId: ${JSON.stringify(postId)}`);
              continue;
            }

            const rawScore = job.postTimestampMap?.[postId];

            const score =
              typeof rawScore === "number" && !isNaN(rawScore)
                ? rawScore
                : Date.now();

            if (rawScore === undefined) {
              logger.warn(`⚠️ Missing timestamp for ${postId}`);
            }

            zEntries.push({
              member: postId,
              score,
            });
          }


          //logger.info(`zEntries: ${zEntries}`);

          /*const missing = createdPostIds.filter(id => !(id in job.postTimestampMap));

          if (missing.length) {
            logger.error(`❌ Missing timestamps for ${missing.length} posts`);
            logger.error(`Sample: ${JSON.stringify(missing.slice(0, 5))}`);
          }*/

          // Spread array into individual arguments
          if (zEntries.length > 0) {
            await redis.zAdd(puzzleKey, ...zEntries);
            const createdList = await redis.zRange(puzzleKey, 0, -1);
            logger.info(`${username} created puzzles: ${JSON.stringify(createdList)}`);
          }

        }

        // Set count safely (NOT incr)
        await redis.set(`user:${username}:puzzleCount`, createdPostIds.length.toString());
        

        //
        const created_total = createdPostIds.length;
        const created_ids = createdPostIds;


        // ---------- Build next profile ----------
        const next = {
          ...prev,
          profileData: {
            ...prevData,
            ...newStats,
            created_total,
            created_ids,
          },
          username,
          updatedBy: username,
          updatedAt: new Date().toISOString(),
        };


        // ---------- Save!!! ----------
        await redis.set(profileKey, JSON.stringify(next));   

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

      res.json({
        showToast: { text: `Job Progress: ${job.index}/${job.total}`}
      });

    } catch (err) {
      logger.error(err);
      showToast: { text: `Job Failed?`}
    }
  });
};
