import { redis } from "@devvit/web/server";
import { Logger } from "../utils/Logger";

const QUEUE_KEY = "puzzles:queue";
const ENABLE_KEY = "puzzles:enabled";

export async function getQueue(): Promise<any[]> {
  return JSON.parse((await redis.get(QUEUE_KEY)) ?? "[]");
}

export async function setQueue(queue: any[]) {
  await redis.set(QUEUE_KEY, JSON.stringify(queue));
}

export async function enqueuePuzzle(puzzle: any) {
  const queue = await getQueue();
  queue.push(puzzle);
  await setQueue(queue);
}

export async function dequeuePuzzle() {
  const queue = await getQueue();
  if (queue.length === 0) return null;

  const puzzle = queue.shift(); // ✅ consume
  await setQueue(queue);

  return puzzle;
}

export async function clearQueue() {
  await redis.set(QUEUE_KEY, JSON.stringify([]));
}

//



/** Replace the entire queue */
export async function replaceQueue(newQueue: any[]): Promise<void> {
  if (!Array.isArray(newQueue)) {
    throw new Error("setQueue expects an array");
  }

  await redis.set(QUEUE_KEY, JSON.stringify(newQueue));
}

//

export async function isPostingEnabled(): Promise<boolean> {
  // default = enabled
  return (await redis.get(ENABLE_KEY)) !== "0";
}

export async function togglePostingEnabled(): Promise<boolean> {
  const enabled = await isPostingEnabled();
  await redis.set(ENABLE_KEY, enabled ? "0" : "1");
  return !enabled;
}

//

export async function getPrevNextDailyPost(
  postId: string,
  logger: Logger
): Promise<{ prev: string | null; next: string | null }> {

  const count = await redis.zCard("dailyList");
  //logger.info("dailyList count =", count);

  // get most recent daily post (highest score)
  let today: string | null = null;
  if (count > 0) {
    //const latest = await redis.zRange("dailyList", count - 1, count - 1);
    const latest = await redis.zRange("dailyList", -1, -1);
    today = latest[0]?.member ?? null;
  }


  //const firstFive = await redis.zRange("dailyList", 0, 50);
  //logger.info("First dailyList entries:", firstFive);

  //logger.info("Looking up postId:", postId);
  // Get index of current post in sorted set
  const rank = await redis.zRank("dailyList", postId);

  //logger.info("Rank result:", rank);

  if (rank === null || rank === undefined) {
    logger.info("postId not found in dailyList, only return today's postId");
    return { prev: null, next: null, today };
  }

  // fetch neighbors by rank
  const neighbors = await redis.zRange(
    "dailyList",
    Math.max(rank - 1, 0),
    rank + 1
  );

  /*
    neighbors can be:
    [prev, current, next]
    OR [current, next]
    OR [prev, current]
  */

  let prev: string | null = null;
  let next: string | null = null;
  

  for (let i = 0; i < neighbors.length; i++) {
    if (neighbors[i].member === postId) {
      console.log("member = postId found")
      prev = neighbors[i - 1]?.member ?? null;
      next = neighbors[i + 1]?.member ?? null;
      break;
    }
  }

  console.log("prev:", prev);
  console.log("next:", next);
  console.log("today:", today);

  // console.log("Rank:", rank);
  // console.log("Neighbors:", neighbors);

  //console.log("Neighbors[i-1].member:", neighbors[rank-1].member);
  //console.log("Neighbors[i+1].member:", neighbors[rank+1].member);

  return { prev, next, today };
}


///


// export async function getNextDailyId(): Promise<number> {
//   const result = await redis.zRange("dailyList", -1, -1, { by: "score" });

//   console.log(result);

//   if (!result.length) return 1;
//   return Number(result[0].score) + 1;
// }
