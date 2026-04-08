//

import fs from "fs";
import path from "path";
import { Router } from 'express';
import { context, reddit, redis } from '@devvit/web/server';
import { Logger } from '../utils/Logger';

import puzzles from "../puzzles.json";

export async function getCurrentLevelCount(): Promise<string> {
  const count = Number((await redis.zCard("levelList")) ?? 0);

  const levelCountStr = count.toString();
  console.log('levelCountStr: ' + (levelCountStr));

  return (levelCountStr);
}


export async function getCurrentDailyCount(): Promise<string> {
  const count = Number((await redis.zCard("dailyList")) ?? 0);

  const dailyCountStr = count.toString();
  console.log('dailyCountStr: ' + (dailyCountStr));

  return (dailyCountStr);
}

// Utility function to format the date
export function formatDate(isoDateString) {
    const date = new Date(isoDateString);

    // Customize the format using toLocaleDateString with options
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    };

    //weekday: 'long',

    let formattedDate = date.toLocaleDateString('en-US', options);

    // Add the correct ordinal suffix for the day
    const day = date.getDate();
    const suffix = (day % 10 === 1 && day !== 11) ? 'st' :
                   (day % 10 === 2 && day !== 12) ? 'nd' :
                   (day % 10 === 3 && day !== 13) ? 'rd' : 'th';

    return formattedDate.replace(day, `${day}${suffix}`);
}


export async function createGamePostFromPuzzle(
  puzzle: QueuedPuzzle
): Promise<Post> {



  const { subredditName } = context;
  if (!subredditName) {
    throw new Error("subredditName is required");
  }

  const {
    levelName,
    levelTag,
    gameData,
    levelCreator,
    nonStandard,
  } = puzzle;


  console.log("Incoming gameData:", gameData);

  //levelDate, overwrite queued date to NOW date when posting 

  const levelDate = new Date().toISOString();
  const levelDateFormatted = formatDate(levelDate);


  

  // ---------- Level IDs ----------
  const currentLevelCount = Number(await getCurrentLevelCount());
  const levelID = (currentLevelCount + 1).toString();
  await redis.set("levelCount", levelID);

  let dailyID = "-1";
  let levelTagNew = levelTag;
  let levelNameNew = `${levelName}`;
  let isCreatePost = false

  if (gameData === "loadBoard=THISISCREATEPOST") {
  	isCreatePost = true
 		levelNameNew = "Create Your Own Sneakle"
 		levelTagNew = "special"
 	}

  
  if (levelTagNew === "daily") {
    const currentDailyCount = Number(await getCurrentDailyCount());
    dailyID = (currentDailyCount + 1).toString();
    await redis.set("dailyCount", dailyID);
  }

  let runAsString = "USER"
  let UGCString = ""
  //replace level name with levelNameNew
  


  if (levelTagNew === "daily") {
  	levelNameNew = `Daily Sneakle #${dailyID}`;
  	runAsString = "APP"
 	} else {
 		UGCString = `UGC -- Puzzle Creator: ${levelCreator} -- Puzzle Title: ${levelNameNew} -- Puzzle Data: ${gameData}`
 	}

 	let postTitle = `${levelNameNew} - ${levelDateFormatted}`
 	if (levelTagNew === "community") { //no date add on community post titles
 		postTitle = `${levelNameNew}`
 	} else if (isCreatePost === true) { //no date add on community post titles
 		postTitle = `${levelNameNew}`
 	}


 	


  // ---------- Create post ----------
  const post = await reddit.submitCustomPost({
    runAs: `${runAsString}`,
    userGeneratedContent: {
	    text: `${UGCString}`,
	  },
    subredditName,
    title: `${postTitle}`,
    splash: {
      appDisplayName: `${levelNameNew}`,
      heading: `${levelNameNew}`,
      description: `Can you solve this ${levelTag} Sneakle?`,
      backgroundUri: "sneakle-splash.png",
      buttonLabel: "Tap to Start",
      appIconUri: "sneakle-favicon.png",
    },
    postData: {
      levelName: levelNameNew,
      levelTag: levelTagNew,
      levelID,
      levelDate,
      levelCreator,
      gameData,
      dailyID,
      totalPlayers: "0",
      totalPlayersCompleted: "0",
      totalGuesses: "0",
      totalTime: "0",
      totalScore: "0",
      nonStandard: nonStandard,
    },
  });


  ///////////////

  if (isCreatePost === true) {

  	console.log("createPost set!");

		// await redis.set("createPost", JSON.stringify({
		//   id: post.id,
		//   url: `https://reddit.com${post.permalink}`
		// }));

		await redis.set("createPostID", post.id);
		await redis.set("createPostURL", `https://reddit.com${post.permalink}`);

	}

  // ---------- Level/Daily Lists ----------
  await redis.zAdd("levelList", {
    member: post.id,
    score: Number(levelID),
  });

  if (dailyID !== "-1") {
    await redis.zAdd("dailyList", {
      member: post.id,
      score: Number(dailyID),
    });

    console.log("Added to dailyList:", post.id, dailyID);
  }

  await redis.hSet(`puzzle:${levelID}`, {
	  postId: post.id,
	  levelName: levelNameNew,
    levelTag,
    levelID,
    levelDate,
    levelCreator,
    gameData,
    dailyID,
    nonStandard: nonStandard,
	});

  //for reverse lookup
	await redis.set(`post:${post.id}:levelID`, levelID);
	//await redis.set(`post:${post.id}:dailyID`, dailyID);



  const zScanResponse = await redis.zScan('levelList', 0); 
  const levelListLength = await redis.zCard('levelList');
  console.log('levelList length: ' + (levelListLength));
  console.log('levelList zScanResponse: ' + JSON.stringify(zScanResponse));

  const zScanResponseD = await redis.zScan('dailyList', 0); 
  const dailyListLength = await redis.zCard('dailyList');
  console.log('dailyList length: ' + (dailyListLength));
  console.log('dailyList zScanResponseD: ' + JSON.stringify(zScanResponseD));




  // --------------- post flair set

  //https://www.reddit.com/mod/sneaklegame_dev/postflair
  //https://www.reddit.com/mod/Sneakle/postflair

  //default daily flair (for sneaklegame_dev)
  let flairIdStr = "1d8f745a-ff9c-11f0-97fb-1ad0899f1390"

  if (subredditName === "sneaklegame_dev") {
  	if (levelTag === "daily") {
  		flairIdStr = "1d8f745a-ff9c-11f0-97fb-1ad0899f1390"
  	} else if (levelTag === "community") {
  		if (nonStandard === "0") {
	  		flairIdStr = "32095c2a-ff9c-11f0-aad2-967f147a0526"
	  	} else {
	  		flairIdStr = "90b33a60-2b12-11f1-a7fc-42d7e8ebd464"
	  	}
	  } else if (levelTag === "special") {
	  	flairIdStr = "4249d556-ff9c-11f0-a5f1-62bf58eea75b"
	  }
	} else if (subredditName === "Sneakle") {
		if (levelTag === "daily") {
			flairIdStr = "97bca5da-204f-11f1-98f2-0a39f26f9f5e"
	  } else if (levelTag === "community") {
	  	if (nonStandard === "0") {
	  		flairIdStr = "b75279ce-204f-11f1-8211-265effb7fbe7"
	  	} else {
	  		flairIdStr = "a3ff6990-2b12-11f1-bb27-0ec6cb8660cc"
	  	}
	  } else if (levelTag === "special") {
	  	flairIdStr = "f3301c4e-204f-11f1-a64f-265effb7fbe7"
	  }
	}

  await reddit.setPostFlair({
	  subredditName: subredditName, // from SetFlairOptions
	  postId: post.id,
	  flairTemplateId: flairIdStr, // or text, etc., per SetFlairOptions
	});


	console.log(`Handle post auto sticky comment now`);

  // const post = req.body.post;
  // const author = req.body.author;

  // Base comment text
  let commentText = `🔠🧩 *Welcome to* ***Sneakle***, *a sneaky hidden word game!*\n\n
**How to play:**\n
1. Swipe across letters to spell out a guess. (Swipe in any direction!)\n
2. Guessing will show you which letters are IN the SECRET word, and which AREN'T.\n
3. Deduce the SECRET word to win!
`;

  // Check postData
  //const postData = post.postData ?? {};

  //console.log("postData:", postData);

  if (levelTag === "daily") {

    //const levelDateFormatted = formatDate(postData.levelDate);

    commentText += `---\n\n📅 This is the **Daily Sneakle #${dailyID}** for *${levelDateFormatted}*.`;

  } else if (levelTag === "community") {

  	const raw = await redis.get("createPost");
		const createPost = raw ? JSON.parse(raw) : null;

    commentText += `---\n\n✏️ u/${levelCreator} created this custom Sneakle: **${levelNameNew}**
    \nCheck out their other puzzles **[✨ HERE ✨](https://www.reddit.com/r/${subredditName}/search/?q=author%3A${levelCreator})**
    \nOr **[✏️ Create Your Own ✏️](${createPost?.url || ''})**`;

  }


  // Create comment
  const autoStickyComment = await reddit.submitComment({
    id: post.id,
    text: commentText,
  });
  await autoStickyComment.distinguish(true);

  console.log(`Comment created and stickied: ${autoStickyComment.id}`);




  console.log("--- createGamePostFromPuzzle:");
  console.log(JSON.stringify(post));

  // res.json({
  //   showToast: { text: `Puzzle "${post.postData.levelName}" posted successfully! levelID: ${levelID} - dailyID: ${dailyID} - Post ID: ${post.id}`}
  // });

  return post;
}


