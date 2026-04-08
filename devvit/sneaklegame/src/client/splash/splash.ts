import { navigateTo, context, requestExpandedMode, showToast } from "@devvit/web/client";
//import { Logger } from '../utils/Logger';
import { Devvit } from "@devvit/public-api";




const startButton = document.getElementById("start-button") as HTMLButtonElement;

startButton.addEventListener("click", (e) => {
  requestExpandedMode(e, "game");
});

const createButton = document.getElementById("create-button") as HTMLButtonElement;



// createButton.addEventListener("click", (e) => {
//   //requestExpandedMode(e, "create");
//   //createPostUrl
// });

const titleElement = document.getElementById("title") as HTMLHeadingElement;
const levelTagElement = document.getElementById("levelTag");
const levelDateElement = document.getElementById("levelDate");
const levelIDElement = document.getElementById("levelID");
const levelNameElement = document.getElementById("levelName");
const levelCreatorElement = document.getElementById("levelCreator");
const levelSizeElement = document.getElementById("levelSize");
const levelStatusElement = document.getElementById("levelStatus");
// const puzzleGridElement = document.getElementById("puzzleGrid")

const totalPlayersElement = document.getElementById("totalPlayers")
// const totalPlayersCompletedElement = document.getElementById("totalPlayersCompleted")
const avgGuessesElement = document.getElementById("avgGuesses")
// const avgTimeElement = document.getElementById("avgTime")
// const avgScoreElement = document.getElementById("avgScore")








// Confirm post data and level name exists 
const { postData } = context;
const postId = context.postId; // "t3_1qnhxpb";


function initTitle() {

  titleElement.innerHTML = `
    <span>Hey <b>${context.username ?? "you"}</b>, can you find the <i>hidden word?</i></span>
  `;

  startButton.innerHTML = "<span class='span-play-icon'>▶</span>Let's Play!"
}

initTitle();


//NOTE, I changed initSplash to be async function so I can use await fetch within to get api/state data
async function initSplash() {



  //specify the postId as a string or just use default context
  

  

  // const userStateData = state.data; 
  //${userData.data.score_combined ?? "score"}


  //
  
  //titleElement.textContent = `Hey ${context.username ?? "user"}, can you find the hidden word? 🔎🔠`;
  // titleElement.innerHTML = `
  //   <span>Hey <b>${context.username ?? "you"}</b>, can you find the <i>hidden word?</i></span>
  // `;



  //for debug
  //const postDataStr = JSON.stringify(postData); 
  //titleElement.textContent = `${postDataStr}`;

  ////////
  //puzzle meta
  ////////


  // if (!postData || !postData.levelName || typeof postData.levelName !== 'string') {
  //   console.log("postData.levelName not found in devvit context");
  // }

  levelNameElement.textContent = `${postData?.levelName || "Sneakle"}`;

  //

  if (postData?.levelTag === "community") {
    levelCreatorElement.innerHTML = `By: <b><a href='https://www.reddit.com/r/Sneakle/search/?q=author%3A${postData?.levelCreator || ""}'>u/${postData?.levelCreator || "-"}</a></b>`;
  }

  //

  const puzzle = {};
  const puzzleData = postData?.gameData;
  let puzSz = "-"

  if (typeof puzzleData === 'string') {
    puzzle.letters = getStringBetweenChars(puzzleData, "=", "&");
    if (puzzle.letters != null) {
      puzSz = Math.floor(Math.sqrt(puzzle.letters.length));
    }
  }

  levelSizeElement.innerHTML = `<b>${puzSz}x${puzSz}</b>`;

  //

  const rawTag = postData.levelTag ?? "none"; //default to "0" if level_status key doesn't exist

  const levelTagMap: Record<string, string> = {
    "daily": "Daily 📅",
    "community": "Community 💗",
    "special": "Special 🌟",
    "none": "",
  };

  const levelTagStr = levelTagMap[String(rawTag)] ?? "-";

  //levelTagElement.innerHTML = `Tag: <b>${levelTagStr || "-"}</b>`;
  levelTagElement.innerHTML = `<b>${levelTagStr || "-"}</b>`;

  if (postData?.nonStandard) {
    if (postData?.nonStandard === "1") {
      levelTagElement.classList.add("nonStandard");
      levelTagElement.innerHTML = `<b>${levelTagStr || "-"}</b><i>⚠️NON-STANDARD!⚠️</i>`;
    }
  }

  //

  

  if (!postData || !postData.levelDate) {

    levelDateElement.classList.add("hidden");

  } else if (postData.levelTag == "community") {

    levelDateElement.classList.add("hidden");

  } else if (postData.levelTag == "daily") {

    const levelDateOrig = postData?.levelDate;
    const levelDateFormatted = formatDate(levelDateOrig);

    //const levelDateFormattedSplit = levelDateFormatted.replace(",", "<br>");

    //const levelDateParts = levelDateFormatted.split(",", 2);

    //levelDateParts[0]; //day of week
    //levelDateParts[1]; //date in Month Day#
    //levelDateParts[2]; //date in Year#

    //const levelDateFormattedSplit = levelDateParts[0]+"<br>"+levelDateParts[1]+", "+levelDateParts[2]

    levelDateElement.innerHTML = `${levelDateFormatted || "-"}`;

    //hide author on daily
    levelCreatorElement.classList.add("hidden");
  }

  //




  //

  levelIDElement.innerHTML = `ID: <b>${postData?.levelID || "-"}</b>`;

  //




  ////////
  //puzzle stats
  ////////

  /*
  const totalPlayersElement = document.getElementById("totalPlayers")
  const totalPlayersCompletedElement = document.getElementById("totalPlayersCompleted")
  const avgGuessesElement = document.getElementById("avgGuesses")
  const avgTimeElement = document.getElementById("avgTime")
  const avgScoreElement = document.getElementById("avgScore")  
  */

  totalPlayersElement.innerHTML = `Players: <b>${postData?.totalPlayers || "0"}</b>`;
  //totalPlayersCompletedElement.innerHTML = `Players Completed: <b>${postData?.totalPlayersCompleted || "0"}</b>`;

  const avgGuessesCalc =
    Number(postData?.totalPlayersCompleted) > 0
      ? Number(postData?.totalGuesses) / Number(postData?.totalPlayersCompleted)
      : 0;

  // const avgTimeCalc =
  //   Number(postData?.totalPlayersCompleted) > 0
  //     ? Number(postData?.totalTime) / Number(postData?.totalPlayersCompleted)
  //     : 0;

  // const avgTimeCalcFormatted = formatTimeFromSteps(avgTimeCalc);


  // const avgScoreCalc =
  //   Number(postData?.totalPlayersCompleted) > 0
  //     ? Number(postData?.totalScore) / Number(postData?.totalPlayersCompleted)
  //     : 0;

  avgGuessesElement.innerHTML = `Avg Guesses: <b>${avgGuessesCalc.toFixed(1) || "0"}</b>`;
  // avgTimeElement.innerHTML = `Avg Time: <b>${avgTimeCalcFormatted || "0:00"}</b>`;
  // avgScoreElement.innerHTML = `Avg Score: <b>${avgScoreCalc.toFixed(0) || "0"}</b>`;



  // const rawcreatePost = await redis.get("createPost");
  // const createPost = rawcreatePost ? JSON.parse(rawcreatePost) : null;
  // const createPostUrl = `${createPost?.url || ''}`


  
  document.body.classList.add("splashLoadComplete");
  
  console.log(context);

  // makePuzzlePrevHTML();



}


async function initIsCreatePost() {

  let thisIsCreatePost = false

  try {
    const createPostRes = await fetch("/api/get-create-post");

    if (createPostRes.ok) {
      const createPostData = await createPostRes.json();

      console.log(createPostData);
      //console.log(createPostData.url);

      if (createPostData?.id === postId) {

        thisIsCreatePost = true
        console.log("thisIsCreatePost = true");

        createButton.classList.add("hidden");
        document.body.classList.add("thisIsCreatePost");


          titleElement.innerHTML = `
          <span>Hey <b>${context.username ?? "you"}</b>, make your own <i>custom Sneakle!</i></span>
        `;
          startButton.innerHTML = "<span class='span-play-icon'>▶</span>🔠✏️ Create!"
        

      } else {

        if (createPostData?.url) {
          //console.log("DO IT!");
          //createButton.href = createPostData.url;
          createButton.disabled = false;
          createButton.onclick = () => {
            window.location.href = createPostData.url;
            navigateTo(createPostData.url);
          };
        } else {
          //console.log("DON'T IT!");
        }
      }
    }
  } catch (err) {
    console.error(err);
  }
}

//initIsCreatePost();

async function initUserState() {
  const res = await fetch(`/api/state?postId=${postId}`);
  const userData = await res.json();

  console.log("userData: ");
  console.log(userData);

  const rawStatus = userData?.level_status ?? "0"; //default to "0" if level_status key doesn't exist

  const levelStatusMap: Record<string, string> = {
    "0": "Unplayed 👀",
    "1": "Unfinished 🤔",
    "2": "Gave up 😭",
    "3": "Complete ✅",
    "4": "You Made This 💗",
  };

  const levelStatusClassMap: Record<string, string> = {
    "0": "status-notplayed",
    "1": "status-started",
    "2": "status-gaveup",
    "3": "status-complete",
    "4": "status-complete",
  };

  const status = levelStatusMap[String(rawStatus)] ?? "-";
  const statusClass = levelStatusClassMap[String(rawStatus)] ?? "";

  //levelStatusElement.innerHTML = `Status: <b>${status ?? "-"}</b>`;
  levelStatusElement.innerHTML = `<b>${status ?? "-"}</b>`;

  if (statusClass !== "") {
    levelStatusElement.classList.add(statusClass);
  }

  levelStatusElement.classList.add("loaded");
}



/* JOIN BUTTON STUFF */

const joinButton = document.getElementById("join-button") as HTMLButtonElement;
const joinButtonWrapper = document.getElementById("join-button-wrapper") as HTMLButtonElement;

joinButton.addEventListener("click", async () => {
  try {
    const res = await fetch("/api/join-subreddit", { method: "POST" });

    if (res.ok) {
      showToast("Joined r/Sneakle!");
      joinButton.textContent = "Joined 💖"; 
      joinButton.disabled = true;
      joinButtonWrapper.classList.remove("wiggle-intermittent");
      createButton.classList.add("nudge-up");
    }
  } catch (err) {
    console.error(err);
  }
});

async function checkSubscription() {
  const res = await fetch("/api/subscription-status");
  const data = await res.json();

  if (data.subscribed) {
    joinButton.textContent = "Joined 💖";
    joinButton.disabled = true;
    joinButtonWrapper.classList.remove("wiggle-intermittent");
    createButton.classList.add("nudge-up");
  }
}





/* makePuzzlePrevHTML */


// Function to generate the puzzle grid using the letters in the postData gameData
/*
function makePuzzlePrevHTML() {

  console.log("makePuzzlePrevHTML happening");

  // const today = new Date(); // Get today's date

  const puzzle = {};

  const puzzleLink = postData?.gameData;


  // Check if the puzzle's date is on or before today's date
  if (typeof puzzleLink === 'string') {

    puzzle.letters = getStringBetweenChars(puzzleLink, "=", "&");

    let puzSz = Math.floor(Math.sqrt(puzzle.letters.length));

    //console.log("puzSz ="+puzSz)

    puzzle.size = puzSz+"x"+puzSz;

    puzzle.lettersFormatted = addStringEveryNthChar(puzzle.letters, "<br>", puzSz);

    // const puzzleItem = document.createElement("a");
    // puzzleItem.classList.add("menu-item");
    // puzzleItem.href = puzzle.link
    // puzzleItem.target = "_self"
    //puzzleItem.textContent = puzzle.date
    // puzzleItem.innerHTML = `<a href="${puzzle.link}" target="_self" class="puzzle-link">${puzzle.date}</a>`;


    // Create details container for each puzzle
    // const puzzleGrid = document.createElement("ul");
    puzzleGridElement.classList.add("puzzle-details");

    puzzleGridElement.classList.add(`sz-${puzzle.size}`);

    // Add puzzle link, size, author, and date to details
    puzzleGridElement.innerHTML = `
      <li class="puzzle-letters">${puzzle.lettersFormatted}</li>
    `;

    // Append details to puzzle item and puzzle item to menu
    // puzzleItem.appendChild(detailsList);
    // menuContainer.appendChild(puzzleItem);

  } else {
    console.log("gameData doesn't exist as string, abort making grid");
  }



  // let thething = document.querySelector(".puzzleMenuWrapper");
  // if (thething) {
  //   //thething.style.visibility = "hidden";
  //   thething.classList.add("show");
  // } 

    


}
*/








////////UTILS/////////

// Utility function to format the date
function formatDate(isoDateString) {
    const date = new Date(isoDateString);

    // Customize the format using toLocaleDateString with options
    const options = { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    };

    let formattedDate = date.toLocaleDateString('en-US', options);

    // Add the correct ordinal suffix for the day
    const day = date.getDate();
    const suffix = (day % 10 === 1 && day !== 11) ? 'st' :
                   (day % 10 === 2 && day !== 12) ? 'nd' :
                   (day % 10 === 3 && day !== 13) ? 'rd' : 'th';

    return formattedDate.replace(day, `${day}${suffix}`);
}

function getStringBetweenChars(str, startChar, endChar) {
  const startIndex = str.indexOf(startChar) + 1;
  const endIndex = str.indexOf(endChar, startIndex);

  if (startIndex === 0 || endIndex === -1) {
    return null; // Start or end character not found
  }

  return str.substring(startIndex, endIndex);
}


function addStringEveryNthChar(originalString, stringToAdd, n) {
  let result = "";
  for (let i = 0; i < originalString.length; i++) {
    result += originalString[i];
    if ((i + 1) % n === 0) {
      result += stringToAdd;
    }
  }
  return result;
}

function toTitleCase(str) {
  return str.toLowerCase().split(' ').map(function(word) {
    return (word.charAt(0).toUpperCase() + word.slice(1));
  }).join(' ');
}

function formatTimeFromSteps(steps) {
  const totalSeconds = Math.floor(steps / 60);

  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;

  // pad with 0 if needed
  return `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

//////////////////////





// async function loadKeys() {
//   const res = await fetch("/api/internal/redis-scan");
//   const keys = await res.json();

//   const container = document.getElementById("keys");
//   container.innerHTML = "";

//   keys.forEach(key => {
//     const btn = document.createElement("button");
//     btn.textContent = key;
//     btn.addEventListener("click", () => loadKey(key));
//     container.appendChild(btn);
//   });
// }

// async function loadKey(key) {
//   const res = await fetch(`/api/internal/redis?key=${encodeURIComponent(key)}`);
//   const data = await res.json();

//   document.getElementById("output").textContent =
//     JSON.stringify(data, null, 2);
// }

// document.getElementById("refresh")
//   .addEventListener("click", loadKeys);

// // initial load
// loadKeys();




////////////////////




//initSplash();






// A wrapper async function to run them in sequence
const initSequentially = async () => {
    try {
        // Wait for the first function to finish
        const result1 = await initSplash();
        
        // The second function will only run after the first one is complete
        // and can use its result
        const result2 = await initIsCreatePost();

        const result3 = await checkSubscription();

        const result4 = await initUserState();

        console.log("4 functions finished."); //, result2);
        
    } catch (error) {
        console.error("An error occurred:", error);
    }
};

initSequentially();

