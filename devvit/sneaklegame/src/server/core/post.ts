import { context, reddit } from "@devvit/web/server";

export const createPost = async () => {
  const { subredditName } = context;
  if (!subredditName) {
    throw new Error("subredditName is required");
  }

  let newChallengeNumber = 1

  return await reddit.submitCustomPost({
    subredditName: subredditName,
    title: `Sneakle #${newChallengeNumber}`,
    splash: {
      appDisplayName: 'Sneakle',
      backgroundUri: 'transparent.png',
    },
    entry: 'default',
    // postData: {
    //   challengeNumber: newChallengeNumber,
    //   queryString: 'loadBoard=MTEDIIIRNQNCIETYGIBAEXEAH&loadSecret=2-7-1-6-11-17'
    //   totalGuesses: 0,
    //   gameState: 'active',
    //   pixels: [
    //     [0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0],
    //     [0, 0, 0, 0, 2, 2, 1, 0, 0, 0, 0],
    //     [0, 0, 0, 2, 2, 1, 1, 1, 0, 0, 0],
    //     [0, 0, 2, 2, 1, 1, 1, 1, 1, 0, 0],
    //     [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    //     [1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1],
    //     [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    //     [0, 0, 2, 2, 1, 1, 1, 1, 1, 0, 0],
    //     [0, 0, 0, 2, 2, 1, 1, 1, 0, 0, 0],
    //     [0, 0, 0, 0, 2, 2, 1, 0, 0, 0, 0],
    //     [0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0]
    //   ],
    // },
  });
};
