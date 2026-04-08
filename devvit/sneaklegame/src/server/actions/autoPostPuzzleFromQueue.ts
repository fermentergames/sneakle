import { Router } from "express";
import { Logger } from "../utils/Logger";
import { dequeuePuzzle, isPostingEnabled } from "../utils/puzzleQueueHelpers";
import { createGamePostFromPuzzle } from "../actions/createGamePost";

export const scheduledPuzzlePostAction = (router: Router): void => {
  router.post("/internal/scheduler/auto-post-daily-puzzle-from-queue", async (_req, res) => {
    const logger = await Logger.Create("Scheduler - Auto Post Puzzle");

    try {
      if (!(await isPostingEnabled())) {
        logger.info("Posting paused");
        res.json({
          showToast: { text: "Auto-posting is currently paused"}
        });
        return;
      }

      const puzzle = await dequeuePuzzle();
      if (!puzzle) {
        logger.info("Queue empty");
        res.json({
          showToast: { text: "Queue is empty. Nothing to post."}
        });
        return;
      }

      const post = await createGamePostFromPuzzle(puzzle);

      //logger.info(`Posted puzzle ${post.id}`);
      res.json({
        showToast: { text: `auto-post-daily-puzzle-from-queue complete!`}
      });
    } catch (err) {
      logger.error("Scheduler failed", err);
      res.status(500).json({ status: "error" });
    }
  });
};
