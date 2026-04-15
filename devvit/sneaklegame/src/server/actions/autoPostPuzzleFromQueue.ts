import { Hono } from "hono";
import { Logger } from "../utils/Logger";
import { dequeuePuzzle, isPostingEnabled } from "../utils/puzzleQueueHelpers";
import { createGamePostFromPuzzle } from "../actions/createGamePost";

export const scheduledPuzzlePostAction = (router: Hono): void => {
  router.post("/internal/scheduler/auto-post-daily-puzzle-from-queue", async (c) => {
    const logger = await Logger.Create("Scheduler - Auto Post Puzzle");

    try {
      if (!(await isPostingEnabled())) {
        logger.info("Posting paused");
        return c.json({
          showToast: { text: "Auto-posting is currently paused"}
        });
      }

      const puzzle = await dequeuePuzzle();
      if (!puzzle) {
        logger.info("Queue empty");
        return c.json({
          showToast: { text: "Queue is empty. Nothing to post."}
        });
      }

      await createGamePostFromPuzzle(puzzle);

      //logger.info(`Posted puzzle ${post.id}`);
      return c.json({
        showToast: { text: `auto-post-daily-puzzle-from-queue complete!`}
      });
    } catch (err) {
      logger.error("Scheduler failed", err);
      return c.json({ status: "error" }, 500);
    }
  });
};
