import { Hono } from "hono";
import { Logger } from "../utils/Logger";
import { reddit, redis } from "@devvit/web/server";

const CANCEL_KEY_PREFIX = "job:cancel:";

export const resyncCreatedKarmaJob = (router: Hono): void => {
  router.post("/internal/scheduler/resync-created-karma", async (c) => {
    const logger = await Logger.Create("Scheduler - Resync Created Karma");

    try {
      const raw = await redis.get("job:resyncCreatedKarma");
      if (!raw) {
        return c.json({ ok: true });
      }

      const job = JSON.parse(raw) as {
        name?: string;
        usernames: string[];
        index: number;
        total: number;
        processedUsernames?: string[];
        startedAt?: string;
        lastRunAt?: string;
        completedAt?: string | null;
      };

      const BATCH_SIZE = 50;
      let jobCanceled = false;

      const processed = new Set(job.processedUsernames ?? []);
      const creatorsAsc = await redis.zRange("lb:alltime:created:total", 0, -1);
      const liveUsernames = creatorsAsc
        .filter((entry) => (Number(entry.score ?? 0) || 0) > 0)
        .map((entry) => entry.member)
        .filter((u): u is string => Boolean(u));

      const pendingUsernames = liveUsernames.filter((u) => !processed.has(u));
      const batchUsernames = pendingUsernames.slice(0, BATCH_SIZE);

      logger.info(`Processing creators batch size=${batchUsernames.length}, pending=${pendingUsernames.length}, totalLive=${liveUsernames.length}`);

      for (let i = 0; i < batchUsernames.length; i++) {
        if (!job.name) {
          logger.warn(`Job missing name at index ${i}, cancelling.`);
          jobCanceled = true;
          break;
        }

        const cancelFlag = await redis.get(`${CANCEL_KEY_PREFIX}${job.name}`);
        if (cancelFlag === "1") {
          logger.info(`Job ${job.name} canceled at index ${i}`);
          jobCanceled = true;
          await redis.del(`${CANCEL_KEY_PREFIX}${job.name}`);
          break;
        }

        const username = batchUsernames[i];
        if (!username) continue;

        const profileKey = `profile:${username}`;
        const profileRaw = await redis.get(profileKey);
        if (!profileRaw) {
          logger.info(`[${i}] Skipping ${username}, no profile exists`);
          processed.add(username);
          continue;
        }

        try {
          const parsed = JSON.parse(profileRaw) as {
            profileData?: Record<string, unknown>;
            username?: string;
            updatedBy?: string;
            updatedAt?: string;
          };
          const prevData = parsed.profileData ?? {};

          const createdIdsValue = prevData.created_ids;
          let postIds: string[] = [];
          if (Array.isArray(createdIdsValue)) {
            postIds = createdIdsValue.map((value) => String(value).trim()).filter(Boolean);
          } else if (typeof createdIdsValue === "string") {
            postIds = createdIdsValue !== "-1"
              ? createdIdsValue.split(",").map((value) => value.trim()).filter(Boolean)
              : [];
          }

          let createdKarma = 0;
          for (const postId of postIds) {
            if (!postId.startsWith("t3_")) {
              // logger.info(`[${i}] ${username} skipping invalid post id: ${postId}`);
              continue;
            }
            try {
              const post = await reddit.getPostById(postId as `t3_${string}`);
              const karma = Number(post.score ?? 0);
              // logger.info(`[${i}] ${username} post ${postId} | title="${title}" | karma=${Number.isFinite(karma) ? karma : 0}`);
              if (Number.isFinite(karma)) {
                createdKarma += karma;
              }
            } catch (err) {
              // logger.error(`[${i}] ${username} failed to load karma for ${postId}`, err);
              // Ignore per-post API failures so one bad post does not stop the batch.
            }
          }

          const next = {
            ...parsed,
            profileData: {
              ...prevData,
              created_karma: String(createdKarma),
            },
            username,
            updatedBy: "system",
            updatedAt: new Date().toISOString(),
          };

          await redis.set(profileKey, JSON.stringify(next));
          await redis.zAdd("lb:alltime:created:karma", { score: createdKarma, member: username });
          processed.add(username);

          logger.info(`[${i}] ${username} created_karma=${createdKarma}`);
        } catch (err) {
          logger.error(`[${i}] Failed to process ${username}`, err);
          // Mark as processed so one malformed profile does not block the queue forever.
          processed.add(username);
        }
      }

      const pendingAfter = liveUsernames.filter((u) => !processed.has(u));
      job.processedUsernames = [...processed];
      job.index = processed.size;
      job.total = liveUsernames.length;
      job.lastRunAt = new Date().toISOString();

      if (jobCanceled) {
        job.completedAt = new Date().toISOString();
        await redis.del("job:resyncCreatedKarma");
        logger.info("Created karma resync job canceled and cleared");
      } else if (pendingAfter.length === 0) {
        // Auto-repeat: reset to start a fresh pass on the next scheduler tick.
        job.processedUsernames = [];
        job.index = 0;
        job.total = liveUsernames.length;
        job.startedAt = new Date().toISOString();
        job.completedAt = null;
        await redis.set("job:resyncCreatedKarma", JSON.stringify(job));
        logger.info(`Created karma resync pass complete; reset for next run (creators=${liveUsernames.length})`);
      } else {
        await redis.set("job:resyncCreatedKarma", JSON.stringify(job));
        logger.info(`Progress saved: ${job.index}/${job.total} (pending=${pendingAfter.length})`);
      }

      return c.json({
        showToast: { text: `Created karma resync: ${job.index}/${job.total}` },
      });
    } catch (err) {
      logger.error(err);
      return c.json({ error: "Created karma resync failed" }, 500);
    }
  });
};
