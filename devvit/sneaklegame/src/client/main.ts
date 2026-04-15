import { InitResponse } from "../shared/types/api";
import { navigateTo } from "@devvit/web/client";

window.redditNavigateTo = function (url: string) {
  navigateTo(`${url}`);
};

declare global {
  interface Window {
    Module: any;
    GM_tick?: (time: number) => void;
    onGameSetWindowSize?: (width: number, height: number) => void;
    manifestFiles?: () => string;
    manifestFilesMD5?: () => string[];
    log_next_game_state?: () => void;
    wallpaper_update_config?: (config: string) => void;
    wallpaper_reset_config?: () => void;
    setAddAsyncMethod?: (method: any) => void;
    setJSExceptionHandler?: (handler: any) => void;
    hasJSExceptionHandler?: () => boolean;
    doJSExceptionHandler?: (exceptionJSON: string) => void;
    setWadLoadCallback?: (callback: any) => void;
    onFirstFrameRendered?: () => void;
    triggerAd?: (adId: string, ...callbacks: any[]) => void;
    triggerPayment?: (itemId: string, callback: any) => void;
    toggleElement?: (id: string) => void;
    set_acceptable_rollback?: (frames: number) => void;
    report_stats?: (statsData: any) => void;
    g_pAddAsyncMethod?: any;
    g_pJSExceptionHandler?: any;
    g_pWadLoadCallback?: any;
    redditNavigateTo?: (url: string) => void;
    addClassElemID?: (elemID: string, className: string) => void;
    removeClassElemID?: (elemID: string, className: string) => void;
    setElementProperty?: (elemID: string, propertyName: string, value: string) => void;
    showGameLeaderboard?: (postId: string, levelName?: string, levelAuthor?: string) => void;
    showGameArchive?: (visible?: boolean | number | string) => void;
    copyToClipboard?: (string: string) => void;
  }
}

// This is the manifest file data structure for type checking security
type RunnerManifest = {
  manifestFiles: string[];
  manifestFilesMD5: string[];
  mainJS?: string;
  unx?: string;
  index?: string;
  runner?: { version?: string; yyc?: boolean };
};


class GameLoader {
  private statusElement: HTMLElement;
  private progressElement: HTMLProgressElement;
  private spinnerElement: HTMLElement;
  private canvasElement: HTMLCanvasElement;
  private loadingElement: HTMLElement;
  private startingHeight?: number;
  private startingWidth?: number;
  private startingAspect?: number;

  constructor() {
    this.statusElement = document.getElementById("status") as HTMLElement;
    this.progressElement = document.getElementById("progress") as HTMLProgressElement;
    this.spinnerElement = document.getElementById("spinner") as HTMLElement;
    this.canvasElement = document.getElementById("canvas") as HTMLCanvasElement;
    this.loadingElement = document.getElementById("loading") as HTMLElement;

    this.canvasElement.addEventListener("click", () => {
      this.canvasElement.focus();
    });
    
    this.setupModule();
    this.setupResizeObserver();
    this.loadGame(); 
  }

  private setupModule() {
    window.Module = {
      preRun: [],
      postRun: [],
      print: (text: string) => {
        console.log(text);
        if (text === "Entering main loop.") {
          this.ensureAspectRatio();
          this.loadingElement.style.display = "none";
        }
      },
      printErr: (text: string) => {
        console.error(text);
      },
      canvas: this.canvasElement,
      setStatus: (text: string) => {
        if (!window.Module.setStatus.last) {
          window.Module.setStatus.last = { time: Date.now(), text: "" };
        }
        if (text === window.Module.setStatus.last.text) return;
        
        const m = text.match(/([^(]+)\((\d+(?:\.\d+)?)\/(\d+)\)/);
        const now = Date.now();
        if (m && now - window.Module.setStatus.last.time < 30) return;
        
        window.Module.setStatus.last.time = now;
        window.Module.setStatus.last.text = text;
        
        if (m) {
          this.progressElement.value = parseInt(m[2]) * 100;
          this.progressElement.max = parseInt(m[3]) * 100;
          this.progressElement.hidden = false;
          this.spinnerElement.hidden = false;
        } else {
          this.progressElement.value = 100; //0;
          this.progressElement.max = 100;
          //this.progressElement.hidden = true;
          
          if (!text) {
            //this.spinnerElement.style.display = "none";
            this.canvasElement.style.display = "block";
            // this.loadingElement.style.display = "none";
          }
        }
        this.statusElement.innerHTML = text;
      },
      totalDependencies: 0,
      monitorRunDependencies: (left: number) => {
        window.Module.totalDependencies = Math.max(window.Module.totalDependencies, left);
        window.Module.setStatus(
          left
            ? `Preparing... (${window.Module.totalDependencies - left}/${window.Module.totalDependencies})`
            : "All downloads complete."
        );
      },
    };
    
    window.Module.setStatus("Downloading...");
    
    window.onerror = (event) => {
      window.Module.setStatus("Exception thrown, see JavaScript console");
      this.spinnerElement.style.display = "none";
      window.Module.setStatus = (text: string) => {
        if (text) window.Module.printErr(`[post-exception status] ${text}`);
      };
    };

    if (typeof window === "object") {
      window.Module.arguments = window.location.search.substr(1).trim().split('&');
      if (!window.Module.arguments[0]) {
        window.Module.arguments = [];
      }
    }
  }

  private setupResizeObserver() {
    window.onGameSetWindowSize = (width: number, height: number) => {
      console.log(`Window size set to width: ${width}, height: ${height}`);
      this.startingHeight = height;
      this.startingWidth = width;
      this.startingAspect = this.startingWidth / this.startingHeight;
    };

    const resizeObserver = new ResizeObserver(() => {
      window.requestAnimationFrame(() => this.ensureAspectRatio());
      setTimeout(() => window.requestAnimationFrame(() => this.ensureAspectRatio()), 100);
    });
    resizeObserver.observe(document.body);

    if (/Android|iPhone|iPod/i.test(navigator.userAgent)) {
      document.body.classList.add("scrollingDisabled");
    }
  }

  private ensureAspectRatio() {

    if (!this.canvasElement || !this.startingHeight || !this.startingWidth) {
      return;
    }

    this.canvasElement.classList.add("active");
    
    const viewportWidth = window.visualViewport?.width ?? window.innerWidth;
    const viewportHeight = window.visualViewport?.height ?? window.innerHeight;
    const maxWidth = viewportWidth;
    const maxHeight = viewportHeight;
    let newHeight: number, newWidth: number;
    var pixelRatio = window.devicePixelRatio; 

    const heightQuotient = this.startingHeight / maxHeight; 
    const widthQuotient = this.startingWidth / maxWidth;

    if (heightQuotient > widthQuotient) {
      newHeight = maxHeight;
      newWidth = newHeight * this.startingAspect!;
    } else {
      newWidth = maxWidth;
      newHeight = newWidth / this.startingAspect!;
    }

    //this.canvasElement.style.height = `${newHeight*pixelRatio}px`; //"100%"; //
    //this.canvasElement.style.width = `${newWidth*pixelRatio}px`; //"100%"; //
    this.canvasElement.style.height = "100%"; //
    this.canvasElement.style.width = "100%"; //   

    //Fermenter added to set canvas element width (not style width) to match window bounds * devicePixelRatio, adapted from YellowAfterlife's browser_hdpi extension.
    console.log("window.devicePixelRatio:"); 
    console.log(window.devicePixelRatio);
    var pixelRatio = window.devicePixelRatio; 
    this.canvasElement.height = Math.round(viewportHeight)* pixelRatio;
    this.canvasElement.width = Math.round(viewportWidth)* pixelRatio;

  }

  private async loadRunnerManifest(): Promise<void> {
    try {
      const res = await fetch("/runner.json", {
        credentials: "include",      // keep Devvit context; same-origin
        cache: "no-cache"            // avoid stale manifest after deploys
      });
      if (!res.ok) throw new Error(`runner.json HTTP ${res.status}`);
      const manifest = (await res.json()) as RunnerManifest;

      // Basic validation
      if (!Array.isArray(manifest.manifestFiles) || !Array.isArray(manifest.manifestFilesMD5)) {
        throw new Error("runner.json missing arrays");
      }
      if (manifest.manifestFiles.length !== manifest.manifestFilesMD5.length) {
        console.warn("[runner.json] manifestFiles and manifestFilesMD5 length mismatch");
      }

      // Wire the global getters from the manifest
      window.manifestFiles = () => manifest.manifestFiles.join(";");
      window.manifestFilesMD5 = () => manifest.manifestFilesMD5.slice(); // return a copy

    } catch (e) {
      console.warn("Falling back to hardcoded manifest (runner.json not available):", e);

      // Fallback to current hardcoded values (this should never happen)
      window.manifestFiles = () =>
        [
          "runner.data",
          "runner.js",
          "runner.wasm",
          "audio-worklet.js",
          "game.unx"
        ].join(";");

      window.manifestFilesMD5 = () =>
        [
          "585214623b669175a702fed30de7d21d",
          "8669aa66d44cfb4f13a098cd6b0296e1",
          "d29ac123833b56dcfbe188f10e5ecb85",
          "e8f1e8db8cf996f8715a6f2164c2e44e",
          "00a26996df3ce310bb5836ef7f4b0e3c"
        ];
    }
  }

  private setupGameMakerGlobals() {

    // GameMaker async method support - make variables globally accessible
    window.g_pAddAsyncMethod = -1;
    window.setAddAsyncMethod = (asyncMethod: any) => {
      window.g_pAddAsyncMethod = asyncMethod;
      console.log("setAddAsyncMethod called with:", asyncMethod);
    };

    // Exception handling - make variables globally accessible
    window.g_pJSExceptionHandler = undefined;
    window.setJSExceptionHandler = (exceptionHandler: any) => {
      if (typeof exceptionHandler === "function") {
        window.g_pJSExceptionHandler = exceptionHandler;
      }
    };

    window.hasJSExceptionHandler = () => {
      return window.g_pJSExceptionHandler !== undefined && typeof window.g_pJSExceptionHandler === "function";
    };

    window.doJSExceptionHandler = (exceptionJSON: string) => {
      if (typeof window.g_pJSExceptionHandler === "function") {
        const exception = JSON.parse(exceptionJSON);
        window.g_pJSExceptionHandler(exception);
      }
    };

    // WAD/Resource loading - make variables globally accessible
    window.g_pWadLoadCallback = undefined;
    window.setWadLoadCallback = (wadLoadCallback: any) => {
      window.g_pWadLoadCallback = wadLoadCallback;
    };

    window.onFirstFrameRendered = () => {
      console.log("First frame rendered!");
    };

    // Ad system stubs
    window.triggerAd = (adId: string, ...callbacks: any[]) => {
      console.log("triggerAd called with adId:", adId);
      // For now, just call the callbacks to simulate ad completion
      if (callbacks.length > 0 && typeof callbacks[0] === 'function') {
        setTimeout(() => callbacks[0](), 100);
      }
    };

    window.triggerPayment = (itemId: string, callback: any) => {
      console.log("triggerPayment called with itemId:", itemId);
      // Simulate payment completion
      if (typeof callback === 'function') {
        setTimeout(() => callback({ id: itemId }), 1000);
      }
    };

    // UI utility functions
    window.toggleElement = (id: string) => {
      const elem = document.getElementById(id);
      if (elem) {
        elem.style.display = elem.style.display === 'block' ? 'none' : 'block';
      }
    };

    // Multiplayer/networking stubs
    let acceptable_rollback_frames = 0;
    window.set_acceptable_rollback = (frames: number) => {
      acceptable_rollback_frames = frames;
      console.log("Set acceptable rollback frames:", frames);
    };

    window.report_stats = (statsData: any) => {
      console.log("Game stats reported:", statsData);
    };

    window.log_next_game_state = () => {
      console.log("Game state logging requested");
    };

    window.wallpaper_update_config = (config: string) => {
      console.log("Wallpaper config update:", config);
    };

    window.wallpaper_reset_config = () => {
      console.log("Wallpaper config reset");
    };

    // Mock accelerometer API to prevent permissions policy violations
    if (!('DeviceMotionEvent' in window)) {
      (window as any).DeviceMotionEvent = class MockDeviceMotionEvent extends Event {
        constructor(type: string, eventInitDict?: any) {
          super(type, eventInitDict);
        }
      };
    }

    if (!('DeviceOrientationEvent' in window)) {
      (window as any).DeviceOrientationEvent = class MockDeviceOrientationEvent extends Event {
        constructor(type: string, eventInitDict?: any) {
          super(type, eventInitDict);
        }
      };
    }
  }

  private async loadGame() {
    try {
      // First try to get initial data from the server
      await this.fetchInitialData();
      
      // Load manifest data that GameMaker runtime expects
      await this.loadRunnerManifest();

      // Setup required global functions before loading GameMaker script
      this.setupGameMakerGlobals();
      
      // Load the GameMaker runner script
      const script = document.createElement('script');
      script.src = '/runner.js';
      script.async = true;
      script.type = 'text/javascript';
      
      script.onload = () => {
        console.log('Game script loaded successfully');
      };
      
      script.onerror = (error) => {
        console.error('Failed to load game script:', error);
        this.statusElement.textContent = 'Failed to load game';
      };
      
      document.head.appendChild(script);
    } catch (error) {
      console.error('Error loading game:', error);
      this.statusElement.textContent = 'Error loading game';
    }
  }

  private async fetchInitialData() {
    try {
      const response = await fetch("/api/init"); //happens in index.ts
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = (await response.json()) as InitResponse;
      if (data.type === "init") {
        console.log(`Game initialized for user: ${data.username}, post: ${data.postId}`);
      } else {
        console.error("Invalid response type from /api/init", data);
      }
    } catch (error) {
      console.error("Error fetching initial data:", error);
    }
  }



  

}

// Initialize the game when the DOM is loaded 
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new GameLoader();
    // setupFullscreenButton();
  });
} else {
  new GameLoader();
  // setupFullscreenButton();
}

// const FULLSCREEN_ICON_ENTER = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" width="20" height="20"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>`;
// const FULLSCREEN_ICON_EXIT  = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" width="20" height="20"><polyline points="4 14 10 14 10 20"/><polyline points="20 10 14 10 14 4"/><line x1="10" y1="14" x2="3" y2="21"/><line x1="21" y1="3" x2="14" y2="10"/></svg>`;

function isInRedditApp(): boolean {
  // Reddit native app WebViews identify themselves in the UA
  return /Reddit\/\d|RedditApp/i.test(navigator.userAgent);
}

function isMobileDevice(): boolean {
  return /Android|iPhone|iPod|iPad/i.test(navigator.userAgent) ||
    ('ontouchstart' in window) ||
    (navigator.maxTouchPoints > 0);
}

// function setupFullscreenButton(): void {
//   // Only show on mobile, and only when fullscreen API is available
//   //if (!isMobileDevice()) return;
//   //if (isInRedditApp()) return;
//   const fsEnabled = document.fullscreenEnabled || (document as any).webkitFullscreenEnabled;
//   if (!fsEnabled) return;

//   const btn = document.createElement('button');
//   btn.id = 'fullscreen-btn';
//   btn.setAttribute('aria-label', 'Enter fullscreen');
//   btn.setAttribute('aria-pressed', 'false');
//   btn.innerHTML = FULLSCREEN_ICON_ENTER;

//   const updateBtn = () => {
//     const isFS = !!(document.fullscreenElement || (document as any).webkitFullscreenElement);
//     btn.setAttribute('aria-pressed', String(isFS));
//     btn.setAttribute('aria-label', isFS ? 'Exit fullscreen' : 'Enter fullscreen');
//     btn.innerHTML = isFS ? FULLSCREEN_ICON_EXIT : FULLSCREEN_ICON_ENTER;
//   };

//   btn.addEventListener('click', () => {
//     const doc = document as any;
//     if (!document.fullscreenElement && !doc.webkitFullscreenElement) {
//       const el = document.documentElement;
//       if (el.requestFullscreen) {
//         el.requestFullscreen();
//       } else if ((el as any).webkitRequestFullscreen) {
//         (el as any).webkitRequestFullscreen();
//       }
//     } else {
//       if (document.exitFullscreen) {
//         document.exitFullscreen();
//       } else if (doc.webkitExitFullscreen) {
//         doc.webkitExitFullscreen();
//       }
//     }
//   });

//   document.addEventListener('fullscreenchange', updateBtn);
//   document.addEventListener('webkitfullscreenchange', updateBtn);

//   document.body.appendChild(btn);

//   console.log("Fullscreen button setup complete");
// }



////////////////////




// function isTypingInInput() {
//   const el = document.activeElement;
//   return el && (
//     el.tagName === "INPUT" ||
//     el.tagName === "TEXTAREA"
//   );
// }
 


// function initCustomUI() {
//   const input = document.getElementById("CreateTypeLettersInput");

//   if (!input) return; // sanity check
  
//   // Capture-phase listener to stop GM key handling
//   document.addEventListener("keydown", function(e) {

//     //if (isTypingInInput()) {
//     if (document.activeElement === input) {
//       e.stopPropagation();
//       document.getElementById("canvas").blur();
//       console.log("isTypingInInput");
//     }

//   }, true);

//   // Example: prepopulate input
//   //input.value = "PREPOPULATED STRING";

//   console.log("Custom UI initialized, input ready for typing");
// }

// // Wait until runner.js has loaded
// window.addEventListener("load", () => {
//   // Sometimes runner.js still hasn't attached all listeners
//   // Use setTimeout to ensure your capture-phase listener comes last
//   setTimeout(initCustomUI, 50); 
// });


document.addEventListener("DOMContentLoaded", () => {
  // Only send callback if NOT in Reddit app (where callbacks may not work reliably).
  // GML defaults to is_reddit_app = 1; only override to 0 if we detect a browser.
  const isRedditApp = isInRedditApp();
  if (!isRedditApp) {
    const msg = { action: "set-is-reddit-app", isRedditApp: 0 };
    window.postMessage(msg, "*");
    if (window.parent && window.parent !== window) {
      window.parent.postMessage(msg, "*");
    }
    console.log("Detected browser, set is_reddit_app to 0");
  } else {
    console.log("Detected Reddit app, skipping postMessage (callbacks unreliable in app)");
  }

  // document.addEventListener("keydown", e => { 
  //   console.log("JS saw key:", e.key);
  // }, true);

  // const closeArchiveMenu = document.getElementById("closeArchiveMenu");

  // closeArchiveMenu.addEventListener("click", () => {
  //   funcCloseArchiveMenu();
  // });

  const closeCreateTypeLetters = document.getElementById("closeCreateTypeLetters");

  closeCreateTypeLetters.addEventListener("click", () => {
    funcCloseCreateTypeLetters();
  });

  const closeCreatePostTitle = document.getElementById("closeCreatePostTitle");

  closeCreatePostTitle.addEventListener("click", () => {
    funcCloseCreatePostTitle();
  });


  const callGameMakerTestBtn = document.getElementById("callGameMakerTestBtn");

  callGameMakerTestBtn.addEventListener("click", () => {

    window.postMessage({
      action: "display_message",
      msg: "THIS IS A MESSAGE FROM JS :)"
    }, "*");
    if (window.parent && window.parent !== window) {
        window.parent.postMessage({
        action: "display_message",
        msg: "THIS IS A MESSAGE FROM JS :)"
      }, "*");
    }

  });

  // const submitTypedLettersBtn = document.getElementById("submitTypedLettersBtn");

  // submitTypedLettersBtn.addEventListener("click", () => {
  //   submitTypedLettersSend();
  // });

  ///////////////

  //TypeLetters

  document.getElementById("submitTypedLettersForm").addEventListener("submit", (e) => {
    e.preventDefault(); // prevent page reload
    // submitTypedLettersSend(); 
    funcCloseCreateTypeLetters();
    document.getElementById('CreateTypeLettersInput').blur();
  });


  // iOS fallbacks
  const btn = document.getElementById("submitTypedLettersBtn");
  btn.addEventListener("touchend", (e) => {
    e.preventDefault(); // stop double trigger
    // submitTypedLettersSend();
    funcCloseCreateTypeLetters();
    document.getElementById('CreateTypeLettersInput').blur();
  });

    const input = document.getElementById("CreateTypeLettersInput") as HTMLInputElement | null;

  // Simple callback: on form submit, send the input value to GML.
  document.getElementById("submitTypedLettersForm")?.addEventListener("submit", (e) => {
    e.preventDefault();
    if (input?.value && input.value.length > 0) {
      const letters = input.value
        .toUpperCase()
        .replace(/[^A-Z]/g, "");
      const msg = { action: "submit-typed-letters", letters: letters };
      window.postMessage(msg, "*");
      if (window.parent && window.parent !== window) {
        window.parent.postMessage(msg, "*");
      }
      input.value = "";
    }
    funcCloseCreateTypeLetters();
  });

  input?.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      // submitTypedLettersSend();
      funcCloseCreateTypeLetters();
      document.getElementById('CreateTypeLettersInput').blur();
    }
  });




  /////////////////

  //PostTitle

  document.getElementById("submitPostTitleForm").addEventListener("submit", (e) => {
    e.preventDefault(); // prevent page reload
    // submitPostTitleSend(); 
    funcCloseCreatePostTitle();
    document.getElementById('CreatePostTitleInput').blur();
  });


  // iOS fallbacks
  const btnPT = document.getElementById("submitPostTitleBtn");
  btnPT.addEventListener("touchend", (e) => {
    e.preventDefault(); // stop double trigger
    // submitPostTitleSend();
    funcCloseCreatePostTitle();
    document.getElementById('CreatePostTitleInput').blur();
  });

  const inputPT = document.getElementById("CreatePostTitleInput");
  inputPT.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      // submitPostTitleSend();
      funcCloseCreatePostTitle();
      document.getElementById('CreatePostTitleInput').blur();
    }
  });


  ////////////

  //archive stuff

  // let archiveCursor = 0;
  // let archiveLoading = false;
  // let archiveHasMore = true;
  // let archiveTag = ""; // or "daily"

  // async function fetchArchivePage() {
  //   if (archiveLoading || !archiveHasMore) return;

  //   archiveLoading = true;

  //   try {
  //     const url = `/api/list-levels?cursor=${archiveCursor}&limit=20&tag=${archiveTag}`;
      
  //     const res = await fetch(url, {
  //       headers: {
  //         Authorization: `Bearer ${reddit_get_token()}`
  //       }
  //     });

  //     const data = await res.json();

  //     renderArchiveItems(data.puzzles);

  //     archiveCursor = data.nextCursor;
  //     archiveHasMore = data.hasMore;

  //   } catch (err) {
  //     console.error("Archive fetch failed", err);
  //   }

  //   archiveLoading = false;
  // }

  // //

  // function renderArchiveItems(puzzles: any[]) {
  //   const container = document.getElementById("archiveList");
  //   if (!container) return;

  //   for (const p of puzzles) {
  //     const el = document.createElement("div");
  //     el.className = "archiveItem";

  //     el.innerHTML = `
  //       <div class="archiveTitle">${p.levelName}</div>
  //       <div class="archiveMeta">
  //         ${p.levelTag} • ${p.levelCreator}
  //       </div>
  //     `;

  //     // click handler
  //     el.onclick = () => {
  //       console.log("Clicked", p.postId);

  //       // call back into GameMaker
  //       window.loadLevelFromPostId?.(p.postId);
  //     };

  //     container.appendChild(el);
  //   }
  // }

  // //

  // function openArchiveModal(tag = "") {
  //   archiveCursor = 0;
  //   archiveHasMore = true;
  //   archiveTag = tag;

  //   const container = document.getElementById("archiveList");
  //   if (container) container.innerHTML = "";

  //   addClassElemID("modalArchive", "active");

  //   fetchArchivePage();
  // }

  // const archiveContainer = document.getElementById("modalArchive");

  // archiveContainer?.addEventListener("scroll", () => {
  //   if (!archiveContainer) return;

  //   const nearBottom =
  //     archiveContainer.scrollTop + archiveContainer.clientHeight >=
  //     archiveContainer.scrollHeight - 200;

  //   if (nearBottom) {
  //     fetchArchivePage();
  //   }
  // });

  // (window as any).loadLevelFromPostId = function(postId: string) {
  //   console.log("Send to GM:", postId);

  //   // however you currently trigger level loads:
  //   window.gml_load_level?.(postId);
  // };


});






// function submitTypedLettersSend() {
//   const letters = document
//     .getElementById("CreateTypeLettersInput")
//     .value
//     .toUpperCase()
//     .replace(/[^A-Z]/g, "");

//     window.postMessage({
//       action: "submit-typed-letters",
//       letters: letters
//     }, "*");
// }

// function submitTypedLettersSend() {
//   const letters = document
//     .getElementById("CreateTypeLettersInput")
//     .value
//     .toUpperCase()
//     .replace(/[^A-Z]/g, "");

//   // --- Try GameMaker bridge first ---
//   // try {
//   //   if (typeof window.__js_call_gml === "function") {
//   //     window.__js_call_gml(
//   //       "scr_submit_typed_letters", // <-- name of your GML script
//   //       "",                      // instance id (optional)
//   //       "",                      // other params (optional)
//   //       0,                       // self
//   //       0,                       // other
//   //       letters                  // argument to pass to GML
//   //     );
//   //     console.log("Sent letters to GameMaker:", letters);
//   //     return;
//   //   }
//   // } catch (err) {
//   //   console.log("GM bridge failed:", err);
//   // }

//   // --- Fallback for normal browser ---
//   // if (window.parent && window.parent !== window) {
//   //   window.parent.postMessage({
//   //     action: "submit-typed-letters",
//   //     letters: letters
//   //   }, "*");
//     // window.postMessage({
//     //   action: "submit-typed-letters",
//     //   letters: letters
//     // }, "*");


//     const msg = JSON.stringify({
//       action: "submit-typed-letters",
//       letters: letters
//     });

//     // send to current window (GameMaker listens here)
//     //window.postMessage(msg, "*"); 
//     setTimeout(() => {
//       window.postMessage(msg, "*");
//     }, 0);

//     // send to parent (Devvit / iframe environments)
//     if (window.parent && window.parent !== window) {
//       //window.parent.postMessage(msg, "*");
//       setTimeout(() => {
//         window.parent.postMessage(msg, "*");
//       }, 0);
//     }

//     //
//     // const iframe = document.getElementById("game-frame");

//     // if (iframe && iframe.contentWindow) {
//     //   iframe.contentWindow.postMessage(msg,"*");
//     // }

//     console.log("Sent letters via postMessage fallback:", letters);
//   //}
// }

// function funcCloseArchiveMenu() {
//   let thething = document.querySelector(".puzzleMenuWrapper");
//   if (thething) {
//     //thething.style.visibility = "hidden";
//     thething.classList.remove("active");
//     console.log("REMOVE "+"active"+" from "+"puzzleMenuWrapper");
//   }
// }

function funcCloseCreateTypeLetters() {
  let thething = document.querySelector(".modalCreateTypeLetters");
  if (thething) {
    //thething.style.visibility = "hidden";
    thething.classList.remove("active");
    console.log("REMOVE "+"active"+" from "+"modalCreateTypeLetters");

    window.postMessage({
      action: "close-modals"
    }, "*");

    if (window.parent !== window) {
        window.parent.postMessage({ action: "close-modals" }, "*");
    }
  }
}


function funcCloseCreatePostTitle() {
  let thething = document.querySelector(".modalCreatePostTitle");
  if (thething) {
    //thething.style.visibility = "hidden";
    thething.classList.remove("active");
    console.log("REMOVE "+"active"+" from "+"modalCreatePostTitle");

    window.postMessage({
      action: "close-modals"
    }, "*");

    if (window.parent !== window) {
        window.parent.postMessage({ action: "close-modals" }, "*");
    }
  }
}


////////////




////////////




window.showElemID = function (elemID: string) {
  let thething = document.getElementById(elemID);
  thething.style.visibility = "visible";
  console.log("SHOW "+elemID);
}

window.hideElemID = function (elemID: string) {
  let thething = document.getElementById(elemID);
  thething.style.visibility = "hidden";
  console.log("HIDE "+elemID);
}


window.addClassElemID = function (elemID: string, className: string) {
  let thething = document.getElementById(elemID);
  //thething.style.visibility = "visible";
  thething.classList.add(className);
  console.log("ADD "+className+" to "+elemID);
};

// function addClassElemID(elemID,className) {
//   let thething = document.getElementById(elemID);
//   //thething.style.visibility = "visible";
//   thething.classList.add(className);
//   console.log("ADD "+className+" to "+elemID); 
// }

window.removeClassElemID = function (elemID: string, className: string) {
//function removeClassElemID(elemID,className) {
  let thething = document.getElementById(elemID);
  thething.classList.remove(className);
  console.log("REMOVE "+className+" from "+elemID);
}

window.setElementProperty = function (elemID: string, propertyName: string, value: string) {
  const el = document.getElementById(elemID);
  if (el) {
    el[propertyName] = value;
    console.log(elemID+" - changed "+propertyName+" to "+value);

    //if changing value, probably an input field
    if (elemID === "CreateTypeLettersInput") {
      el.focus();
      // el.select();
      console.log("focusing and selecting")
    }
  }
}


/////////////////////////




/////////////////////////

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



window.copyToClipboard = function (string: string) {
  console.log("copyToClipboard:");
  console.log(string);

  if (navigator.canShare) {
    // Mobile / native share
    navigator.share({
      //title: "Sneakle",
      text: string,
      //url: window.location.href,
    }).catch((err) => console.error("Share failed:", err));
  } else if (navigator.clipboard) {
    // Desktop / clipboard
    navigator.clipboard.writeText(string)
      .then(() => console.log("Copied to clipboard!"))
      .catch((err) => console.error("Clipboard copy failed:", err));
  } else {
    // Fallback for really old browsers
    const textarea = document.createElement("textarea");
    textarea.value = string;
    document.body.appendChild(textarea);
    textarea.select();
    try {
      document.execCommand("copy");
      console.log("Copied to clipboard (fallback)!");
    } catch (err) {
      console.error("Fallback copy failed:", err);
    }
    document.body.removeChild(textarea);
  }
};


// function copyToClipboard(string) {

//   console.log("copyToClipboard:")
//   console.log(string)

//   if (navigator.canShare) {
//     navigator.share({
//       title: "Sneakle",
//       text: string,
//       url: window.location.href,
//     });
//   } else {
//     //functionality for desktop
//   }

// }

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

// ============================================
// GAME LEADERBOARD MODAL - called from GameMaker
// ============================================

const GAME_LEADERBOARD_MODAL_ID = "game-leaderboard-modal";
const GAME_LEADERBOARD_LIMIT = 25;
let gameLeaderboardPostId: string = "";
let gameLeaderboardLevelName: string = "";
let gameLeaderboardLevelAuthor: string = "";
let gameLeaderboardPageState = 1;
let gameLeaderboardTotalPagesState = 1;
type GameLeaderboardMetric = "score" | "time";
let gameLeaderboardMetricState: GameLeaderboardMetric = "score";
let gameLeaderboardModalWired = false;

function escapeHtmlGame(v: unknown): string {
  return String(v ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function setupGameLeaderboardModal() {
  const modal = document.getElementById(GAME_LEADERBOARD_MODAL_ID);
  if (!modal || gameLeaderboardModalWired) return;

  const closeButton = modal.querySelector(".game-leaderboard-close") as HTMLButtonElement | null;
  const prevBtn = modal.querySelector("#game-leaderboard-prev-btn") as HTMLButtonElement | null;
  const nextBtn = modal.querySelector("#game-leaderboard-next-btn") as HTMLButtonElement | null;
  const scoreTab = modal.querySelector("#game-leaderboard-tab-score") as HTMLButtonElement | null;
  const timeTab = modal.querySelector("#game-leaderboard-tab-time") as HTMLButtonElement | null;

  // Close overlay when clicking outside the card
  modal.addEventListener("click", () => {
    closeGameLeaderboardModal();
  });

  // Close when clicking the X button
  closeButton?.addEventListener("click", (e) => {
    e.stopPropagation();
    closeGameLeaderboardModal();
  });

  // Prevent closing when clicking inside the card
  const card = modal.querySelector(".game-leaderboard-card") as HTMLDivElement | null;
  card?.addEventListener("click", (event) => {
    event.stopPropagation();
  });

  // Close on Escape key
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !modal.classList.contains("hidden")) {
      closeGameLeaderboardModal();
    }
  });

  prevBtn?.addEventListener("click", () => {
    if (gameLeaderboardPageState <= 1) return;
    gameLeaderboardPageState -= 1;
    void loadGameLeaderboardData();
  });

  nextBtn?.addEventListener("click", () => {
    if (gameLeaderboardPageState >= gameLeaderboardTotalPagesState) return;
    gameLeaderboardPageState += 1;
    void loadGameLeaderboardData();
  });

  scoreTab?.addEventListener("click", () => {
    if (gameLeaderboardMetricState === "score") return;
    gameLeaderboardMetricState = "score";
    gameLeaderboardPageState = 1;
    updateGameLeaderboardMetricTabs();
    void loadGameLeaderboardData();
  });

  timeTab?.addEventListener("click", () => {
    if (gameLeaderboardMetricState === "time") return;
    gameLeaderboardMetricState = "time";
    gameLeaderboardPageState = 1;
    updateGameLeaderboardMetricTabs();
    void loadGameLeaderboardData();
  });

  gameLeaderboardModalWired = true;
}

function updateGameLeaderboardMetricTabs() {
  const scoreTab = document.getElementById("game-leaderboard-tab-score") as HTMLButtonElement | null;
  const timeTab = document.getElementById("game-leaderboard-tab-time") as HTMLButtonElement | null;

  const scoreActive = gameLeaderboardMetricState === "score";
  scoreTab?.classList.toggle("is-active", scoreActive);
  scoreTab?.setAttribute("aria-selected", scoreActive ? "true" : "false");

  const timeActive = gameLeaderboardMetricState === "time";
  timeTab?.classList.toggle("is-active", timeActive);
  timeTab?.setAttribute("aria-selected", timeActive ? "true" : "false");
}

function openGameLeaderboardModal() {
  setupGameLeaderboardModal();
  const modal = document.getElementById(GAME_LEADERBOARD_MODAL_ID);
  if (modal) {
    modal.classList.remove("hidden");
    gameLeaderboardPageState = 1;
    gameLeaderboardMetricState = "score";
    updateGameLeaderboardMetricTabs();
    void loadGameLeaderboardData();
  }
}

function closeGameLeaderboardModal() {
  const modal = document.getElementById(GAME_LEADERBOARD_MODAL_ID);
  if (modal) {
    modal.classList.add("hidden");
  }
}

function medalForGameRank(rank: number): string {
  if (rank === 1) return "🥇";
  if (rank === 2) return "🥈";
  if (rank === 3) return "🥉";
  return "";
}

function formatGameLeaderboardValue(metric: GameLeaderboardMetric, value: number): string {
  if (metric === "time") {
    // GML stores timer units at 60 ticks per second.
    const ticks = Math.max(0, Math.floor(value));
    const hours = ticks >= 216000 ? Math.floor(((ticks / 60) / 60) / 60) : 0;
    const minutes = ticks >= 3600 ? Math.floor((ticks / 60) / 60) - (hours * 60) : 0;
    const seconds = (ticks / 60 >> 0) - (minutes * 60) - (hours * 60 * 60);

    const secondStr = String(seconds).padStart(2, "0");
    if (hours > 0) {
      const minuteStr = String(minutes).padStart(2, "0");
      return `${hours}:${minuteStr}:${secondStr}`;
    }
    return `${minutes}:${secondStr}`;
  }
  return value.toLocaleString();
}

function updateGameLeaderboardPaginationUi(page: number, totalPages: number) {
  const prevBtn = document.getElementById("game-leaderboard-prev-btn") as HTMLButtonElement | null;
  const nextBtn = document.getElementById("game-leaderboard-next-btn") as HTMLButtonElement | null;
  const meta = document.getElementById("game-leaderboard-page-meta") as HTMLSpanElement | null;

  if (meta) {
    meta.textContent = `Page ${page} / ${Math.max(1, totalPages)}`;
  }
  if (prevBtn) {
    prevBtn.disabled = page <= 1;
  }
  if (nextBtn) {
    nextBtn.disabled = page >= totalPages;
  }
}

async function loadGameLeaderboardData() {
  const list = document.getElementById("game-leaderboard-list") as HTMLDivElement | null;
  const selfRowEl = document.getElementById("game-leaderboard-self-row") as HTMLDivElement | null;
  const levelNameEl = document.getElementById("game-leaderboard-levelname") as HTMLParagraphElement | null;
  const authorEl = document.getElementById("game-leaderboard-author") as HTMLParagraphElement | null;
  if (!list) return;

  if (levelNameEl) {
    levelNameEl.textContent = gameLeaderboardLevelName ? gameLeaderboardLevelName : "";
  }
  if (authorEl) {
    authorEl.textContent = gameLeaderboardLevelAuthor ? `by u/${gameLeaderboardLevelAuthor}` : "";
  }

  list.innerHTML = `<p class="game-leaderboard-loading">Loading leaderboard...</p>`;

  try {
    const res = await fetch(
      `/api/leaderboard?postId=${encodeURIComponent(gameLeaderboardPostId)}&metric=${encodeURIComponent(gameLeaderboardMetricState)}&limit=${GAME_LEADERBOARD_LIMIT}&page=${gameLeaderboardPageState}`
    );
    if (!res.ok) {
      list.innerHTML = `<p class="game-leaderboard-loading">Could not load leaderboard.</p>`;
      return;
    }

    const data = await res.json() as {
      metric?: GameLeaderboardMetric;
      scoreLabel?: string;
      top?: Array<{ rank: number; username: string; score: number; guesses?: number }>;
      aroundMe?: Array<{ rank: number; username: string; score: number; guesses?: number }>;
      me?: { rank: number; username: string; score: number; guesses?: number } | null;
      totalPlayers?: number;
      page?: number;
      totalPages?: number;
      generatedAt?: number;
    };

    gameLeaderboardMetricState = data.metric === "time" ? "time" : "score";
    updateGameLeaderboardMetricTabs();
    const valueLabel = data.scoreLabel ?? (gameLeaderboardMetricState === "time" ? "Time" : "Score");

    gameLeaderboardPageState = Math.max(1, Number(data.page ?? gameLeaderboardPageState));
    gameLeaderboardTotalPagesState = Math.max(1, Number(data.totalPages ?? 1));
    updateGameLeaderboardPaginationUi(gameLeaderboardPageState, gameLeaderboardTotalPagesState);

    const entries = data.top ?? [];
    if (entries.length === 0) {
      list.innerHTML = `<p class="game-leaderboard-loading">No ranked players yet.</p>`;
      if (selfRowEl) {
        selfRowEl.innerHTML = `Your Rank: <b>Unranked</b>`;
      }
      return;
    }

    const rows = entries
      .map((entry) => {
        const medal = medalForGameRank(entry.rank);
        const topRankClass = entry.rank === 1
          ? "is-rank-1"
          : entry.rank === 2
            ? "is-rank-2"
            : entry.rank === 3
              ? "is-rank-3"
              : "";
        const isSelf = data.me?.username === entry.username;
        const guessesValue = Number(entry.guesses ?? 0) || 0;
        const guessesLabel = `${guessesValue.toLocaleString()} ${guessesValue === 1 ? "guess" : "guesses"}`;
        return `<div class="game-leaderboard-row ${topRankClass} ${isSelf ? "is-self" : ""}">
          <span class="game-lb-rank">${medal ? `${medal} ` : ""}#${entry.rank}</span>
          <span class="game-lb-user">u/${escapeHtmlGame(entry.username)}${isSelf ? ' <span class="game-lb-you">(You)</span>' : ""}</span>
          <span class="game-lb-score"><span class="game-lb-score-main">${formatGameLeaderboardValue(gameLeaderboardMetricState, entry.score)}</span><span class="game-lb-guesses">${guessesLabel}${guessesValue === 1 ? ' <span class="game-lb-guesses-emoji">🎯</span>' : ""}</span></span>
        </div>`;
      })
      .join("");

    const selfContent = data.me
      ? `Your Rank: <b>#${data.me.rank}</b> • ${valueLabel}: <b>${formatGameLeaderboardValue(gameLeaderboardMetricState, data.me.score)}</b>`
      : `Your Rank: <b>Unranked</b>`;
    if (selfRowEl) selfRowEl.innerHTML = selfContent;

    const totalLabel = (data.totalPlayers ?? entries.length).toLocaleString();
    const rankStart = (gameLeaderboardPageState - 1) * GAME_LEADERBOARD_LIMIT + 1;
    const rankEnd = rankStart + entries.length - 1;
    const rankLabel = gameLeaderboardPageState === 1 && entries.length <= GAME_LEADERBOARD_LIMIT
      ? `Top ${entries.length}`
      : `Ranks ${rankStart}-${rankEnd}`;
    list.innerHTML = `
      <div class="game-leaderboard-head">
        <span>${rankLabel}</span>
        <span>${totalLabel} players</span>
      </div>
      <div class="game-leaderboard-rows">${rows}</div>
    `;
  } catch (err) {
    console.error(err);
    list.innerHTML = `<p class="game-leaderboard-loading">Could not load leaderboard.</p>`;
  }
}

// Expose to GameMaker
window.showGameLeaderboard = function (postId: string, levelName?: string, levelAuthor?: string) {
  if (!postId || postId.trim() === "") {
    console.error("showGameLeaderboard: postId is required");
    return;
  }
  gameLeaderboardPostId = postId;
  gameLeaderboardLevelName = String(levelName ?? "");
  gameLeaderboardLevelAuthor = String(levelAuthor ?? "");
  openGameLeaderboardModal();
};

// ============================================
// GAME ARCHIVE MODAL - called from GameMaker
// ============================================

const GAME_ARCHIVE_MODAL_ID = "game-archive-modal";
const GAME_ARCHIVE_LIMIT = 12;
type GameArchiveCategory = "all" | "daily" | "community";
type GameArchiveSort = "date" | "players" | "avg" | "karma";
type GameArchiveNonStandardFilter = "any" | "standard";

let gameArchiveCategoryState: GameArchiveCategory = "all";
let gameArchiveSortState: GameArchiveSort = "date";
let gameArchivePageState = 1;
let gameArchiveTotalPagesState = 1;
let gameArchiveSizeState = "";
let gameArchiveNonStandardState: GameArchiveNonStandardFilter = "any";
let gameArchiveUnplayedOnlyState = false;
let gameArchiveAuthorState = "";
let gameArchiveTitleState = "";
let gameArchiveLoadFallbackTimeout = 0;
let gameArchiveLoadFallbackPostId = "";
let gameArchiveIsLoadingPost = false;

function gameArchivePostUrl(postId: string): string {
  const barePostId = postId.startsWith("t3_") ? postId.slice(3) : postId;
  return `https://www.reddit.com/comments/${encodeURIComponent(barePostId)}`;
}

function setGameArchivePostLoading(isLoading: boolean) {
  gameArchiveIsLoadingPost = isLoading;

  const loadingEl = document.getElementById("game-archive-post-loading");
  if (loadingEl) {
    loadingEl.classList.toggle("hidden", !isLoading);
  }

  const entryButtons = document.querySelectorAll("#game-archive-list .game-archive-entry-toggle") as NodeListOf<HTMLButtonElement>;
  entryButtons.forEach((button) => {
    button.disabled = isLoading;
  });

  const summary = document.getElementById("game-archive-summary-row") as HTMLDivElement | null;
  if (summary && isLoading) {
    summary.textContent = "Loading post...";
  }
}

function tryLoadPuzzleInGame(postId: string): boolean {
  const normalizedPostId = String(postId ?? "").trim();
  if (!normalizedPostId) {
    return false;
  }

  const msg = { action: "load-archive-post", postId: normalizedPostId };
  window.postMessage(msg, "*");
  if (window.parent && window.parent !== window) {
    window.parent.postMessage(msg, "*");
  }

  return true;
}

function openPuzzleFromGameArchive(postId: string) {
  if (gameArchiveIsLoadingPost) return;

  const normalizedPostId = String(postId ?? "").trim();
  if (!normalizedPostId) return;

  setGameArchivePostLoading(true);
  gameArchiveLoadFallbackPostId = normalizedPostId;
  window.clearTimeout(gameArchiveLoadFallbackTimeout);

  const attemptedCallback = tryLoadPuzzleInGame(normalizedPostId);
  if (!attemptedCallback) {
    closeGameArchiveModal();
    navigateTo(gameArchivePostUrl(normalizedPostId));
    return;
  }

  // If GML callback works it will call showGameArchive("false") quickly.
  // If modal remains open, fall back to direct post navigation.
  gameArchiveLoadFallbackTimeout = window.setTimeout(() => {
    if (gameArchiveLoadFallbackPostId !== normalizedPostId) return;
    const modal = document.getElementById(GAME_ARCHIVE_MODAL_ID);
    const modalStillOpen = Boolean(modal && !modal.classList.contains("hidden"));
    if (!modalStillOpen) return;

    closeGameArchiveModal();
    navigateTo(gameArchivePostUrl(normalizedPostId));
  }, 450);
}

function setupGameArchiveModal() {
  if (document.getElementById(GAME_ARCHIVE_MODAL_ID)) {
    return;
  }

  const modalOverlay = document.createElement("div");
  modalOverlay.id = GAME_ARCHIVE_MODAL_ID;
  modalOverlay.className = "game-archive-overlay hidden";
  modalOverlay.innerHTML = `
    <div class="game-archive-card" role="dialog" aria-modal="true" aria-labelledby="game-archive-title">
      <button type="button" class="game-archive-close" aria-label="Close">✕</button>
      <div class="game-archive-top">
        <h2 id="game-archive-title">🗂️ PUZZLE ARCHIVE 🗂️</h2>
        <p class="game-archive-post-loading hidden" id="game-archive-post-loading">Loading post...</p>
        <div class="game-archive-tabs" id="game-archive-tabs">
          <button type="button" class="game-archive-tab is-active" data-category="all">All</button>
          <button type="button" class="game-archive-tab" data-category="daily">🗓️ Daily</button>
          <button type="button" class="game-archive-tab" data-category="community">🌎 Community</button>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <span style="font-size: 0.8rem; color: rgb(255 255 255 / 65%);">↕️</span>
          <div class="game-archive-sort-tabs" id="game-archive-sort-tabs">
          <button type="button" class="game-archive-sort-tab is-active" data-sort="date">🗓️ Date</button>
          <button type="button" class="game-archive-sort-tab" data-sort="players">👥 Players</button>
          <button type="button" class="game-archive-sort-tab" data-sort="avg">📊 Avg Score</button>
          <button type="button" class="game-archive-sort-tab" data-sort="karma"><span class="karma-arrow">▲</span> Upvotes</button>
        </div>
        </div>
        <div class="game-archive-options-row">
          <label class="game-archive-toggle-wrap game-archive-unplayed-wrap" for="game-archive-unplayed-toggle">
            <input type="checkbox" id="game-archive-unplayed-toggle" class="game-archive-toggle" />
            <span>Unplayed Only</span>
          </label>
          <details class="game-archive-more-options">
          <summary class="game-archive-more-summary">More options</summary>
          <div class="game-archive-more-body">
            <div class="game-archive-search-row">
              <input type="text" id="game-archive-title-input" class="game-archive-input" placeholder="Search title ⌕" maxlength="80" />
              <input type="text" id="game-archive-author-input" class="game-archive-input" placeholder="Search author ⌕" maxlength="40" />
            </div>
            <div class="game-archive-filter-row">
              <label class="game-archive-toggle-wrap" for="game-archive-nonstandard-toggle">
                <input type="checkbox" id="game-archive-nonstandard-toggle" class="game-archive-toggle" />
                <span>Hide Non-Standard</span>
              </label>
              <select id="game-archive-size-select" class="game-archive-select">
                <option value="">Any Size</option>
                <option value="3">3x3</option>
                <option value="4">4x4</option>
                <option value="5">5x5</option>
                <option value="6">6x6</option>
                <option value="7">7x7</option>
                <option value="8plus">8x8+</option>
              </select>
              <button type="button" class="game-archive-filter-btn" id="game-archive-reset-btn">Reset</button>
            </div>
          </div>
          </details>
        </div>
      </div>
      <div class="game-archive-list" id="game-archive-list">
        <p class="game-archive-loading">Loading archive...</p>
      </div>
      <div class="game-archive-pagination">
        <div class="game-archive-summary" id="game-archive-summary-row"></div>
        <div class="game-archive-page-controls">
          <button type="button" class="game-archive-page-btn" id="game-archive-prev-btn">◀  Prev</button>
          <span class="game-archive-page-meta" id="game-archive-page-meta">Page 1 / 1</span>
          <button type="button" class="game-archive-page-btn" id="game-archive-next-btn">Next  ▶</button>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(modalOverlay);

  const modalCard = modalOverlay.querySelector(".game-archive-card") as HTMLDivElement | null;
  const closeButton = modalOverlay.querySelector(".game-archive-close") as HTMLButtonElement | null;

  modalOverlay.addEventListener("click", () => {
    closeGameArchiveModal();
  });

  closeButton?.addEventListener("click", (event) => {
    event.stopPropagation();
    closeGameArchiveModal();
  });

  modalCard?.addEventListener("click", (event) => {
    event.stopPropagation();
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !modalOverlay.classList.contains("hidden")) {
      closeGameArchiveModal();
    }
  });

  const categoryTabs = modalOverlay.querySelectorAll(".game-archive-tab") as NodeListOf<HTMLButtonElement>;
  categoryTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      gameArchiveCategoryState = (tab.dataset.category ?? "all") as GameArchiveCategory;
      gameArchivePageState = 1;
      setGameArchiveActiveCategory(gameArchiveCategoryState);
      void loadGameArchiveData();
    });
  });

  const sortTabs = modalOverlay.querySelectorAll(".game-archive-sort-tab") as NodeListOf<HTMLButtonElement>;
  sortTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      gameArchiveSortState = (tab.dataset.sort ?? "date") as GameArchiveSort;
      gameArchivePageState = 1;
      setGameArchiveActiveSort(gameArchiveSortState);
      void loadGameArchiveData();
    });
  });

  const titleInput = modalOverlay.querySelector("#game-archive-title-input") as HTMLInputElement | null;
  const authorInput = modalOverlay.querySelector("#game-archive-author-input") as HTMLInputElement | null;
  const sizeSelect = modalOverlay.querySelector("#game-archive-size-select") as HTMLSelectElement | null;
  const nonStandardToggle = modalOverlay.querySelector("#game-archive-nonstandard-toggle") as HTMLInputElement | null;
  const unplayedToggle = modalOverlay.querySelector("#game-archive-unplayed-toggle") as HTMLInputElement | null;
  const resetBtn = modalOverlay.querySelector("#game-archive-reset-btn") as HTMLButtonElement | null;
  const prevBtn = modalOverlay.querySelector("#game-archive-prev-btn") as HTMLButtonElement | null;
  const nextBtn = modalOverlay.querySelector("#game-archive-next-btn") as HTMLButtonElement | null;

  const applyArchiveFilters = () => {
    gameArchiveTitleState = titleInput?.value.trim() ?? "";
    gameArchiveAuthorState = authorInput?.value.trim() ?? "";
    gameArchiveSizeState = sizeSelect?.value ?? "";
    gameArchiveNonStandardState = nonStandardToggle?.checked ? "standard" : "any";
    gameArchiveUnplayedOnlyState = unplayedToggle?.checked ?? false;
    gameArchivePageState = 1;
    void loadGameArchiveData();
  };

  let gameArchiveFilterDebounce = 0;
  const scheduleGameArchiveFilterApply = () => {
    window.clearTimeout(gameArchiveFilterDebounce);
    gameArchiveFilterDebounce = window.setTimeout(() => {
      applyArchiveFilters();
    }, 220);
  };

  resetBtn?.addEventListener("click", () => {
    gameArchiveCategoryState = "all";
    gameArchiveSortState = "date";
    gameArchivePageState = 1;
    gameArchiveTotalPagesState = 1;
    gameArchiveSizeState = "";
    gameArchiveNonStandardState = "any";
    gameArchiveUnplayedOnlyState = false;
    gameArchiveAuthorState = "";
    gameArchiveTitleState = "";
    if (titleInput) titleInput.value = "";
    if (authorInput) authorInput.value = "";
    if (sizeSelect) sizeSelect.value = "";
    if (nonStandardToggle) nonStandardToggle.checked = false;
    if (unplayedToggle) unplayedToggle.checked = false;
    setGameArchiveActiveCategory(gameArchiveCategoryState);
    setGameArchiveActiveSort(gameArchiveSortState);
    updateGameArchivePaginationUi(1, 1);
    void loadGameArchiveData();
  });

  [titleInput, authorInput].forEach((input) => {
    input?.addEventListener("input", () => {
      scheduleGameArchiveFilterApply();
    });
    input?.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault();
        applyArchiveFilters();
      }
    });
  });

  sizeSelect?.addEventListener("change", () => {
    gameArchiveSizeState = sizeSelect.value;
    gameArchivePageState = 1;
    void loadGameArchiveData();
  });

  nonStandardToggle?.addEventListener("change", () => {
    gameArchiveNonStandardState = nonStandardToggle.checked ? "standard" : "any";
    gameArchivePageState = 1;
    void loadGameArchiveData();
  });

  unplayedToggle?.addEventListener("change", () => {
    gameArchiveUnplayedOnlyState = unplayedToggle.checked;
    gameArchivePageState = 1;
    void loadGameArchiveData();
  });

  prevBtn?.addEventListener("click", () => {
    if (gameArchivePageState <= 1) return;
    gameArchivePageState -= 1;
    void loadGameArchiveData();
  });

  nextBtn?.addEventListener("click", () => {
    if (gameArchivePageState >= gameArchiveTotalPagesState) return;
    gameArchivePageState += 1;
    void loadGameArchiveData();
  });
}

function setGameArchiveActiveCategory(category: GameArchiveCategory) {
  const tabs = document.querySelectorAll("#game-archive-tabs .game-archive-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((button) => {
    button.classList.toggle("is-active", button.dataset.category === category);
  });
}

function setGameArchiveActiveSort(sort: GameArchiveSort) {
  const tabs = document.querySelectorAll("#game-archive-sort-tabs .game-archive-sort-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((button) => {
    button.classList.toggle("is-active", button.dataset.sort === sort);
  });
}

function updateGameArchivePaginationUi(page: number, totalPages: number) {
  const prevBtn = document.getElementById("game-archive-prev-btn") as HTMLButtonElement | null;
  const nextBtn = document.getElementById("game-archive-next-btn") as HTMLButtonElement | null;
  const meta = document.getElementById("game-archive-page-meta") as HTMLSpanElement | null;

  if (meta) {
    meta.textContent = `Page ${page} / ${Math.max(1, totalPages)}`;
  }
  if (prevBtn) {
    prevBtn.disabled = page <= 1;
  }
  if (nextBtn) {
    nextBtn.disabled = page >= totalPages;
  }
}

function closeGameArchiveModal() {
  const modal = document.getElementById(GAME_ARCHIVE_MODAL_ID);
  if (modal) {
    modal.classList.add("hidden");
  }
  setGameArchivePostLoading(false);
  gameArchiveLoadFallbackPostId = "";
  window.clearTimeout(gameArchiveLoadFallbackTimeout);
}

function openGameArchiveModal() {
  setupGameArchiveModal();
  gameArchiveCategoryState = "all";
  gameArchiveSortState = "date";
  gameArchivePageState = 1;
  gameArchiveTotalPagesState = 1;
  gameArchiveSizeState = "";
  gameArchiveNonStandardState = "any";
  gameArchiveUnplayedOnlyState = false;
  gameArchiveAuthorState = "";
  gameArchiveTitleState = "";
  setGameArchiveActiveCategory(gameArchiveCategoryState);
  setGameArchiveActiveSort(gameArchiveSortState);
  updateGameArchivePaginationUi(1, 1);
  setGameArchivePostLoading(false);
  const modal = document.getElementById(GAME_ARCHIVE_MODAL_ID);
  if (modal) {
    modal.classList.remove("hidden");
  }
  void loadGameArchiveData();
}

function formatGameArchiveDate(value: string | undefined): string {
  if (!value) return "Unknown date";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Unknown date";
  return date.toLocaleDateString("en-US", {
    month: "numeric",
    day: "numeric",
    year: "2-digit",
  });
}

function gameArchiveCategoryLabel(category: string): string {
  if (category === "daily") return "🗓️ Daily";
  if (category === "community") return "🌎 Community";
  return "All";
}

async function loadGameArchiveData() {
  const list = document.getElementById("game-archive-list") as HTMLDivElement | null;
  const summary = document.getElementById("game-archive-summary-row") as HTMLDivElement | null;
  const titleInput = document.getElementById("game-archive-title-input") as HTMLInputElement | null;
  const authorInput = document.getElementById("game-archive-author-input") as HTMLInputElement | null;
  const sizeSelect = document.getElementById("game-archive-size-select") as HTMLSelectElement | null;
  const nonStandardToggle = document.getElementById("game-archive-nonstandard-toggle") as HTMLInputElement | null;
  const unplayedToggle = document.getElementById("game-archive-unplayed-toggle") as HTMLInputElement | null;
  if (!list) return;

  if (titleInput && titleInput.value !== gameArchiveTitleState) titleInput.value = gameArchiveTitleState;
  if (authorInput && authorInput.value !== gameArchiveAuthorState) authorInput.value = gameArchiveAuthorState;
  if (sizeSelect && sizeSelect.value !== gameArchiveSizeState) sizeSelect.value = gameArchiveSizeState;
  if (nonStandardToggle) nonStandardToggle.checked = gameArchiveNonStandardState === "standard";
  if (unplayedToggle) unplayedToggle.checked = gameArchiveUnplayedOnlyState;

  list.innerHTML = `<p class="game-archive-loading">Loading archive...</p>`;

  try {
    const params = new URLSearchParams({
      page: String(gameArchivePageState),
      limit: String(GAME_ARCHIVE_LIMIT),
      sort: gameArchiveSortState,
      nonStandard: gameArchiveNonStandardState,
      unplayedOnly: gameArchiveUnplayedOnlyState ? "1" : "0",
    });
    if (gameArchiveCategoryState !== "all") params.set("tag", gameArchiveCategoryState);
    if (gameArchiveSizeState) params.set("size", gameArchiveSizeState);
    if (gameArchiveAuthorState) params.set("author", gameArchiveAuthorState);
    if (gameArchiveTitleState) params.set("title", gameArchiveTitleState);

    const res = await fetch(`/api/list-levels?${params.toString()}`, { cache: "no-store" });
    if (!res.ok) {
      list.innerHTML = `<p class="game-archive-loading">Could not load archive.</p>`;
      if (summary) summary.innerHTML = "";
      return;
    }

    const data = await res.json() as {
      puzzles?: Array<{
        postId: string;
        levelName?: string;
        levelCreator?: string;
        levelTag?: string;
        levelDate?: string;
        nonStandard?: string;
        totalPlayers?: number | string;
        avgScore?: number | string;
        karma?: number | string;
        puzzleSize?: number | string;
        viewerPlayed?: boolean;
      }>;
      totalFiltered?: number;
      page?: number;
      totalPages?: number;
    };

    gameArchivePageState = Math.max(1, Number(data.page ?? gameArchivePageState));
    gameArchiveTotalPagesState = Math.max(1, Number(data.totalPages ?? 1));
    updateGameArchivePaginationUi(gameArchivePageState, gameArchiveTotalPagesState);

    const puzzles = data.puzzles ?? [];
    if (puzzles.length === 0) {
      list.innerHTML = `
        <p class="game-archive-loading">No puzzles matched those filters.</p>
      `;
      if (summary) {
        summary.textContent = "Try broadening the filters or clearing search terms.";
      }
      return;
    }

    const rows = puzzles.map((puzzle) => {
      const tagValue = String(puzzle.levelTag ?? "");
      const sizeValue = Number(puzzle.puzzleSize ?? 0);
      const totalPlayers = Number(puzzle.totalPlayers ?? 0);
      const avgScore = Number(puzzle.avgScore ?? 0);
      const karma = Number(puzzle.karma ?? 0);
      const totalPlayersLabel = Number.isFinite(totalPlayers) ? totalPlayers.toLocaleString() : "0";
      const avgScoreLabel = Number.isFinite(avgScore)
        ? avgScore.toLocaleString(undefined, { maximumFractionDigits: 0 })
        : "0";
      const rulesLabel = String(puzzle.nonStandard ?? "0") === "1" ? "⚠️ Non-Standard" : "Standard";
      const playedLabel = puzzle.viewerPlayed ? "Played" : "Unplayed";
      const categoryLabel = gameArchiveCategoryLabel(tagValue);
      const tagIcon = tagValue === "daily" ? "🗓️" : tagValue === "community" ? "🌎" : "🧩";
      const authorInline = tagValue === "daily" ? "" : `u/${escapeHtmlGame(puzzle.levelCreator ?? "unknown")}`;
      const restMetaParts = [
        formatGameArchiveDate(puzzle.levelDate),
        `👥 ${totalPlayersLabel}`,
        `<span><span class="karma-arrow">▲</span> ${karma.toLocaleString()}</span>`,
      ];
      const restMeta = restMetaParts.join(" · ");
      const inlineMetaHtml = authorInline
        ? `<span class="game-archive-entry-author">${escapeHtmlGame(authorInline)}</span><span class="game-archive-entry-inline-meta-rest"> · ${restMeta}</span>`
        : `<span class="game-archive-entry-inline-meta-rest">${restMeta}</span>`;
      return `
        <article class="game-archive-entry" data-post-id="${escapeHtmlGame(puzzle.postId)}">
          <span class="game-archive-played-pill ${puzzle.viewerPlayed ? "is-played" : "is-unplayed"}" aria-hidden="true"></span>
          <button type="button" class="game-archive-entry-toggle" data-post-id="${escapeHtmlGame(puzzle.postId)}">
            <span class="game-archive-entry-copy">
              <span class="game-archive-entry-title-row">
                <span class="game-archive-entry-tag-icon" aria-hidden="true" title="${escapeHtmlGame(categoryLabel)}">${tagIcon}</span>
                <span class="game-archive-entry-title">${escapeHtmlGame(puzzle.levelName ?? "Untitled Puzzle")}</span>
              </span>
              <span class="game-archive-entry-inline-meta">${inlineMetaHtml}</span>
            </span>
            <span class="game-archive-entry-caret">▶</span>
          </button>
          <div class="game-archive-entry-meta">
            <span class="game-archive-meta-pill">${gameArchiveCategoryLabel(String(puzzle.levelTag ?? ""))}</span>
            <span class="game-archive-meta-pill">${sizeValue > 0 ? `${sizeValue}x${sizeValue}` : "Unknown size"}</span>
            <span class="game-archive-meta-pill">Avg Score: ${avgScoreLabel}</span>
            <span class="game-archive-meta-pill">${rulesLabel}</span>
          </div>
        </article>
      `;
    }).join("");

    const start = (gameArchivePageState - 1) * GAME_ARCHIVE_LIMIT + 1;
    const end = start + puzzles.length - 1;
    const totalFiltered = Number(data.totalFiltered ?? puzzles.length);
    if (summary) {
      summary.textContent = `Showing ${start}-${end} of ${totalFiltered.toLocaleString()} puzzles`;
    }

    list.innerHTML = `
      <div class="game-leaderboard-head">
        <span>${totalFiltered.toLocaleString()} puzzles</span>
        <span>Sorted by ${gameArchiveSortState === "avg" ? "avg score" : gameArchiveSortState}</span>
      </div>
      <div class="game-archive-rows">${rows}</div>
    `;

    const toggleButtons = list.querySelectorAll(".game-archive-entry-toggle") as NodeListOf<HTMLButtonElement>;
    toggleButtons.forEach((button) => {
      button.addEventListener("click", () => {
        if (gameArchiveIsLoadingPost) return;
        const selectedPostId = button.dataset.postId ?? "";
        openPuzzleFromGameArchive(selectedPostId);
      });
    });

    setGameArchivePostLoading(gameArchiveIsLoadingPost);
  } catch (err) {
    console.error(err);
    list.innerHTML = `<p class="game-archive-loading">Could not load archive.</p>`;
    if (summary) summary.innerHTML = "";
  }
}

window.showGameArchive = function (visible?: boolean | number | string) {
  let shouldShow = true;

  if (typeof visible === "boolean") {
    shouldShow = visible;
  } else if (typeof visible === "number") {
    shouldShow = visible !== 0;
  } else if (typeof visible === "string") {
    const normalized = visible.trim().toLowerCase();
    shouldShow = !["0", "false", "hide", "close", "off"].includes(normalized);
  }

  if (shouldShow) {
    openGameArchiveModal();
    return;
  }
  closeGameArchiveModal();
};

////////////////////////////////////




// const ATTRIBUTES = [
//   'accept', 'accept-charset', 'accesskey', 'action', 'align', 'alt', 'async', 'autocomplete', 'autofocus', 'autoplay', 'bgcolor', 'border', 'charset', 
//   'checked', 'cite', 'class', 'color', 'cols', 'colspan', 'content', 'contenteditable', 'controls', 'coords', 'data', 'datetime', 'default', 'defer', 
//   'dir', 'dirname', 'disabled', 'download', 'draggable', 'dropzone', 'enctype', 'for', 'form', 'formaction', 'headers', 'height', 'hidden', 'high', 
//   'href', 'hreflang', 'http-equi', 'ismap', 'kind', 'label', 'lang', 'list', 'loop', 'low', 'max', 'maxlength', 'media', 'method', 'min', 'multiple', 
//   'muted', 'name', 'novalidate', 'onabort', 'onafterprint', 'onbeforeprint', 'onbeforeunload', 'onblur', 'oncanplay', 'oncanplaythrough', 'onchange', 
//   'onclick', 'oncontextmenu', 'oncopy', 'oncuechange', 'oncut', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart',
//   'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'onhashchange', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 
//   'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onoffline', 'ononline',
//   'onpagehide', 'onpageshow', 'onpaste', 'onpause', 'onplay', 'onplaying', 'onpopstate', 'onprogress', 'onratechange', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked',
//   'onseeking', 'onselect', 'onstalled', 'onstorage', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'onunload', 'onvolumechange', 'onwaiting', 'onwheel', 'open', 
//   'optimum', 'pattern', 'placeholder', 'poster', 'preload', 'readonly', 'rel', 'required', 'reversed', 'rows', 'rowspan', 'sandbox', 'scope', 'selected', 'shape', 'size',
//   'sizes', 'span', 'spellcheck', 'src', 'srcdoc', 'srclang', 'srcset', 'start', 'step', 'style', 'tabindex', 'target', 'title', 'translate', 'type', 'usemap', 'value', 'width', 'wrap'
// ];

// let _html_elements_mouse_position: [number, number] = [0, 0];

// window.htmlElementsCreate = function (
//   type: string,
//   id: string,
//   parent?: string,
//   insert_after?: string
// ): boolean {
//   const element = document.createElement(type);
//   element.setAttribute("id", id);

//   if (parent) {
//     if (insert_after) {
//       document.getElementById(insert_after)?.insertAdjacentElement("afterend", element);
//     } else {
//       document.getElementById(parent)?.insertAdjacentElement("afterbegin", element);
//     }
//   } else {
//     document.body.appendChild(element);
//   }

//   return true;
// };

// window.htmlElementsRemove = function (id: string): boolean {
//   const el = document.getElementById(id);
//   if (el) {
//     el.remove();
//     return true;
//   }
//   return false;
// };

// window.htmlElementsSetProperty = function (
//   id: string,
//   key: string,
//   value: any
// ): boolean {
//   const element = document.getElementById(id);
//   if (!element) return false;

//   if (key === "content") {
//     element.innerHTML = typeof value === "undefined" ? "" : value;
//     return true;
//   }

//   if (ATTRIBUTES.indexOf(key) >= 0) {
//     if (typeof value === "undefined") {
//       element.removeAttribute(key);
//     } else {
//       element.setAttribute(key, value);
//     }
//     return true;
//   }

//   (element as any)[key] = value;
//   return true;
// };

// window.htmlStyleAdd = function (rule: string): void {
//   const sheet = document.styleSheets[0];
//   sheet.insertRule(rule, 1);
// };

// window.htmlElementsGetX = function (id: string): number | null {
//   const element = document.getElementById(id);
//   if (!element) return null;
//   return element.getBoundingClientRect().x;
// };

// window.htmlElementsGetY = function (id: string): number | null {
//   const element = document.getElementById(id);
//   if (!element) return null;
//   return element.getBoundingClientRect().y;
// };

// window.htmlElementsGetMouseX = function (): number {
//   return _html_elements_mouse_position[0];
// };

// window.htmlElementsGetMouseY = function (): number {
//   return _html_elements_mouse_position[1];
// };

// window.htmlElementsStoreMousePosition = function (e: MouseEvent): void {
//   let pageX = e.pageX;
//   let pageY = e.pageY;

//   if (pageX === undefined) {
//     pageX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
//     pageY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
//   }

//   _html_elements_mouse_position = [pageX, pageY];
// };

// document.onmousemove = function (e: MouseEvent) {
//   window.htmlElementsStoreMousePosition(e);
// };


///////////////




