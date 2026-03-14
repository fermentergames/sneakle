
import { navigateTo } from '@devvit/web/client';

function redditNavigateTo(url) {

    console.log("redditNavigateTo");
    
    console.log("redditNavigateTo "+url);

    navigateTo(url);
}



/*function showShare() {
	let thebutt = document.getElementById("shareButton");
	//let thebuttShow = document.getElementById("btnShow");
	//let thebuttHide = document.getElementById("btnHide");
	thebutt.style.visibility = "visible";
	//thebuttShow.style.visibility = "hidden";
	//thebuttHide.style.visibility = "visible";
	console.log("SHOW share button");
}

function hideShare() {
	let thebutt = document.getElementById("shareButton");
	//let thebuttShow = document.getElementById("btnShow");
	//let thebuttHide = document.getElementById("btnHide");
	thebutt.style.visibility = "hidden";
	//thebuttShow.style.visibility = "visible";
	//thebuttHide.style.visibility = "hidden";
	console.log("HIDE share button");
}*/

function showElemID(elemID) {
	let thething = document.getElementById(elemID);
	thething.style.visibility = "visible";
	console.log("SHOW "+elemID);
}

function hideElemID(elemID) {
	let thething = document.getElementById(elemID);
	thething.style.visibility = "hidden";
	console.log("HIDE "+elemID);
}

function addClassElemID(elemID,className) {
	let thething = document.getElementById(elemID);
	//thething.style.visibility = "visible";
	thething.classList.add(className);
	console.log("ADD "+className+" to "+elemID);
}

function removeClassElemID(elemID,className) {
	let thething = document.getElementById(elemID);
	//thething.style.visibility = "hidden";
	thething.classList.remove(className);
	console.log("REMOVE "+className+" from "+elemID);
}

function changeQuery(key1,value1,key2,value2) {

	//THAINORAYMFUJCET_2-6-10-15

	console.log("New Query Should Be "+key1+"="+value1);
	console.log("New Query Should Be "+key2+"="+value2);

	if ('URLSearchParams' in window) {
	  const url = new URL(window.location)
	  url.searchParams.set(key1, value1)
	  url.searchParams.set(key2, value2)
	  //location.assign(url);
	  history.pushState(null, '', url);
	  //history.replaceState(null, '', url);
	}

}

function reloadPage() {
	//location.assign(url);
	//Force a hard reload to clear the cache if supported by the browser
	window.location.reload(true);
}




 function loadParentQueryString() {

 	console.log("loadParentQueryString happening");

    var queryStringKeyValue = window.parent.location.search.replace('?', '').split('&');
    var qsJsonObject = {};
    if (queryStringKeyValue != '') {
        for (i = 0; i < queryStringKeyValue.length; i++) {
            qsJsonObject[queryStringKeyValue[i].split('=')[0]] = queryStringKeyValue[i].split('=')[1];
        }
    }

	console.log(qsJsonObject);

    return qsJsonObject;

}

function useParentLoadBoardQueryString() {

	console.log("useParentLoadBoardQueryString happening");
	let parentsLoadBoard = loadParentQueryString().loadBoard;
	console.log("Parent's loadBoard is "+parentsLoadBoard);
	
	return parentsLoadBoard;

}

function useParentLoadSecretQueryString() {

	console.log("useParentLoadSecretQueryString happening");
	let parentsLoadSecret = loadParentQueryString().loadSecret;
	console.log("Parent's loadSecret is "+parentsLoadSecret);
	
	return parentsLoadSecret;

}




function copyToClipboard(string) {

  if (navigator.canShare) {
    navigator.share({
      //title: "Sneakle",
      //text: string,
      url: window.location.href,
    });
  } else {
    //functionality for desktop
  }
    

}




function getPathFromUrl(url) {
  return url.split("?")[0];
}

function get_window_host() {
  //return getPathFromUrl(window.location.href);
	let urlwithoutquery = window.location.origin + window.location.pathname;
	return urlwithoutquery;
}

function focus_window() {
	window.focus();
}


//////////////////////////////////


// // Sample data for puzzles, each with a link, size, author, and date
// const puzzlesExample = [
    
//     {
//         link: "?loadBoard=DARKNESSHELLFIRE&loadSecret=8-11-10-5-1-6-3",
//         title: "#666",
//         author: "Satan",
//         date: "2024-12-02"
//     },
//     {
//         link: "?loadBoard=DARKNESSHELLFIRE&loadSecret=8-11-10-5-1-6-3",
//         title: "#4",
//         author: "Satan",
//         date: "2024-11-03"
//     },
//     {
//         link: "?loadBoard=HIDEWORDINTOGRID&loadSecret=4-7-12-16-15-10-13",
//         title: "#4",
//         author: "Satan",
//         date: "2024-11-03"
//     },
//     {
//         link: "?loadBoard=LIVELOVELAFFWORD&loadSecret=11-6-5-9-14-13",
//         title: "#4",
//         author: "Acey",
//         date: "2024-11-03"
//     },
//     {
//         link: "?loadBoard=WHATWORDISINGRID&loadSecret=3-7-11-16",
//         title: "#4",
//         author: "Acey",
//         date: "2024-11-03"
//     },
//     {
//         link: "?loadBoard=IOOWYDSCDVEPENTGAAAIIJMEU&loadSecret=13-14-9-3-4",
//         title: "#4",
//         author: "Satan",
//         date: "2024-11-02"
//     },
//     {
//         link: "?loadBoard=UWXVMPENENUDDLKHSEEAATWOR&loadSecret=23-19-20-15-9-8-7-13",
//         title: "#4",
//         author: "Satan",
//         date: "2024-11-01"
//     },
//     {
//         link: "?loadBoard=BDOEBKNSIROEERBAMDIRGGATE&loadSecret=6-7-12-13",
//         title: "#4",
//         author: "Acey",
//         date: "2024-10-31"
//     },
//     {
//         link: "?loadBoard=IYEIORAOABEANEAEPCINMALNI&loadSecret=17-23-22-18-14-10-5",
//         title: "#4",
//         author: "Acey",
//         date: "2024-10-30"
//     },
//     {
//         link: "?loadBoard=MUSIXIDMTETEEALCHDYRATDAE&loadSecret=16-17-13-18-23-24-20",
//         title: "#3",
//         author: "Acey",
//         date: "2024-10-29"
//     },
//     {
//         link: "?loadBoard=FDTSUREOSIAIOTME&loadSecret=4-3-6-7-11-15",
//         title: "#2",
//         author: "Acey",
//         date: "2024-10-28"
//     },
    
// ];


// //load puzzles
// const puzzles = [];

// var jsonURL = 'https://fermentergames.github.io/sneakle/puzzles.json'+'?nocache=' + (new Date()).getTime()

// fetch(jsonURL)
//     .then(response => {

//         console.log("jsonURL = "+jsonURL);

//         if (!response.ok) {
//             throw new Error('Network response was not ok');
//         }
//         return response.json();
//     })
//     .then(data => {
//         puzzles.push(...data);
//         //console.log(puzzles); // Logs the array to verify
//     })
//     .catch(error => {
//         console.error('There was a problem with the fetch operation:', error);
//     });



// // Function to generate the puzzle list
// function generatePuzzleList() {

//     console.log("generatePuzzleList happening");
//     console.log(puzzles);


//     const menuContainer = document.querySelector(".puzzleMenu");
//     const today = new Date(); // Get today's date
//     let puzzleListCount = puzzles.length;

//     //adjust puzzleListCount for puzzles later than today
//     puzzles.forEach(puzzle => {
//         const puzzleDateQuickCheck = new Date(puzzle.date);
//         if (puzzleDateQuickCheck > today) {
//         	puzzleListCount -= 1
//         }
//     });


//     if (menuContainer) {
//         menuContainer.innerHTML = "";

//         puzzles.forEach(puzzle => {

//         	// Convert puzzle date to Date object for comparison
//             const puzzleDate = new Date(puzzle.date);

//             // Check if the puzzle's date is on or before today's date
//             if (puzzleDate <= today) {

            	
//             	puzzle.title = "#"+puzzleListCount;
//             	puzzleListCount -= 1;

//             	puzzle.letters = getStringBetweenChars(puzzle.link, "=", "&");

//             	let puzSz = Math.floor(Math.sqrt(puzzle.letters.length))

//             	//console.log("puzSz ="+puzSz)

//             	puzzle.size = puzSz+"x"+puzSz

//             	puzzle.lettersFormatted = addStringEveryNthChar(puzzle.letters, "<br>", puzSz);

//     	    	const puzzleItem = document.createElement("a");
//     	        puzzleItem.classList.add("menu-item");
//     	        puzzleItem.href = puzzle.link
//     	        puzzleItem.target = "_self"
//     	        //puzzleItem.textContent = puzzle.date
//     	        // puzzleItem.innerHTML = `<a href="${puzzle.link}" target="_self" class="puzzle-link">${puzzle.date}</a>`;


//     	        // Create details container for each puzzle
//     	        const detailsList = document.createElement("ul");
//     	        detailsList.classList.add("puzzle-details");

//     	        // Add puzzle link, size, author, and date to details
//     	        detailsList.innerHTML = `
    	        	
//     	        	<li class="puzzle-item puzzle-title">${puzzle.title}</li>
//     	        	<li class="puzzle-item puzzle-letters">${puzzle.lettersFormatted}</li>
    	        	
//     	        	<li class="puzzle-item puzzle-date">${formatDate(puzzle.date)}</li>
//     	            <li class="puzzle-item puzzle-author">by ${puzzle.author}</li>
//     	        `;

//     	        // Append details to puzzle item and puzzle item to menu
//     	        puzzleItem.appendChild(detailsList);
//     	        menuContainer.appendChild(puzzleItem);

//         	}
//         });


//         let thething = document.querySelector(".puzzleMenuWrapper");
//         if (thething) {
//         	//thething.style.visibility = "hidden";
//         	thething.classList.add("show");
//         }

//     }


// }

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

// Generate the puzzle list on page load
//window.onload = generatePuzzleList;



function funcCloseArchiveMenu() {
	let thething = document.querySelector(".puzzleMenuWrapper");
    if (thething) {
    	//thething.style.visibility = "hidden";
    	thething.classList.remove("show");
    	console.log("REMOVE "+"show"+" from "+"puzzleMenuWrapper");
    }
}





