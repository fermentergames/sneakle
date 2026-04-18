import { navigateTo, context, requestExpandedMode, showToast } from "@devvit/web/client";
//import { Logger } from '../utils/Logger';
import { Devvit } from "@devvit/public-api";




const startButton = document.getElementById("start-button") as HTMLButtonElement;
const debugButton = document.getElementById("debug-button") as HTMLButtonElement | null;
const debugButtonWrapper = document.getElementById("debug-button-wrapper") as HTMLDivElement | null;
const previewVideo = document.querySelector(".img-prev") as HTMLVideoElement | null;

const DEBUG_USERS = new Set(["FermenterGames"]);
const DEBUG_PAGE_PATH = "/debug.html";

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
const contentElement = document.querySelector(".content.border-gradient") as HTMLDivElement | null;
// const puzzleGridElement = document.getElementById("puzzleGrid")

const totalPlayersElement = document.getElementById("totalPlayers")
// const totalPlayersCompletedElement = document.getElementById("totalPlayersCompleted")
const avgGuessesElement = document.getElementById("avgGuesses")
// const avgTimeElement = document.getElementById("avgTime")
// const avgScoreElement = document.getElementById("avgScore")








// Confirm post data and level name exists 
const { postData } = context;
const postId = context.postId; // "t3_1qnhxpb";

const API_TIMEOUT_MS = 4000;
const NONSTANDARD_MODAL_ID = "nonstandard-modal";
const PROFILE_MODAL_ID = "profile-modal";
const LEADERBOARD_MODAL_ID = "leaderboard-modal";
const ARCHIVE_MODAL_ID = "archive-modal";
type LeaderboardCategory = "daily" | "community" | "unlimited" | "created";
type LeaderboardMetric = "total" | "avg" | "karma" | "players";
type ArchiveCategory = "all" | "daily" | "community";
type ArchiveSort = "date" | "players" | "avg" | "karma";
type ArchiveNonStandardFilter = "any" | "standard";
const LEADERBOARD_PAGE_SIZE = 25;
const ARCHIVE_PAGE_SIZE = 12;
let leaderboardCategoryState: LeaderboardCategory = "daily";
let leaderboardMetricState: LeaderboardMetric = "total";
let leaderboardPageState = 1;
let leaderboardTotalPagesState = 1;
let archiveCategoryState: ArchiveCategory = "all";
let archiveSortState: ArchiveSort = "date";
let archivePageState = 1;
let archiveTotalPagesState = 1;
let archiveSizeState = "";
let archiveNonStandardState: ArchiveNonStandardFilter = "any";
let archiveUnplayedOnlyState = false;
let archiveAuthorState = "";
let archiveTitleState = "";

function archivePostUrl(postId: string): string {
  const subreddit = context.subredditName ?? "Sneakle";
  const barePostId = postId.startsWith("t3_") ? postId.slice(3) : postId;
  return `https://www.reddit.com/r/${encodeURIComponent(subreddit)}/comments/${encodeURIComponent(barePostId)}`;
}

function setupNonStandardModal() {
  if (document.getElementById(NONSTANDARD_MODAL_ID)) {
    return;
  }

  const modalOverlay = document.createElement("div");
  modalOverlay.id = NONSTANDARD_MODAL_ID;
  modalOverlay.className = "nonstandard-modal-overlay hidden";
  modalOverlay.innerHTML = `
    <div class="nonstandard-modal-card" role="dialog" aria-modal="true" aria-labelledby="nonstandard-modal-title">
      <button type="button" class="nonstandard-modal-close" aria-label="Close">✕</button>
      <h2 id="nonstandard-modal-title">NON-STANDARD</h2>
      <p>In a NON-STANDARD puzzle, the author's Secret Word could be ANYTHING - short words, proper nouns, non-English words, and non-dictionary words are all allowed!</p>
      <p class="nonstandard-modal-sep">-</p>
      <p>This also means that your guesses aren't limited to the dictionary either. Guess to your heart's content!</p>
      <p>Good luck! :)</p>
    </div>
  `;

  document.body.appendChild(modalOverlay);

  const modalCard = modalOverlay.querySelector(".nonstandard-modal-card") as HTMLDivElement | null;
  const closeButton = modalOverlay.querySelector(".nonstandard-modal-close") as HTMLButtonElement | null;

  modalOverlay.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  closeButton?.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  modalCard?.addEventListener("click", (event) => {
    event.stopPropagation();
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !modalOverlay.classList.contains("hidden")) {
      modalOverlay.classList.add("hidden");
    }
  });
}

function openNonStandardModal() {
  setupNonStandardModal();
  const modalOverlay = document.getElementById(NONSTANDARD_MODAL_ID);
  if (modalOverlay) {
    modalOverlay.classList.remove("hidden");
  }
}

function setupProfileModal() {
  if (document.getElementById(PROFILE_MODAL_ID)) {
    return;
  }

  const modalOverlay = document.createElement("div");
  modalOverlay.id = PROFILE_MODAL_ID;
  modalOverlay.className = "splash-modal-overlay hidden";
  modalOverlay.innerHTML = `
    <div class="splash-modal-card" role="dialog" aria-modal="true" aria-labelledby="profile-modal-title">
      <button type="button" class="splash-modal-close" aria-label="Close">✕</button>
      <h2 id="profile-modal-title">YOUR SNEAKLE STATS</h2>
      <p class="profile-username" id="profile-modal-username"></p>
      <div class="profile-modal-body" id="profile-modal-body">
        <p class="profile-loading">Loading stats...</p>
      </div>
    </div>
  `;

  document.body.appendChild(modalOverlay);

  const modalCard = modalOverlay.querySelector(".splash-modal-card") as HTMLDivElement | null;
  const closeButton = modalOverlay.querySelector(".splash-modal-close") as HTMLButtonElement | null;

  modalOverlay.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  closeButton?.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  modalCard?.addEventListener("click", (event) => {
    event.stopPropagation();
  });
}

function setupLeaderboardModal() {
  if (document.getElementById(LEADERBOARD_MODAL_ID)) {
    return;
  }

  const modalOverlay = document.createElement("div");
  modalOverlay.id = LEADERBOARD_MODAL_ID;
  modalOverlay.className = "splash-modal-overlay hidden";
  modalOverlay.innerHTML = `
    <div class="splash-modal-card leaderboard-modal-card" role="dialog" aria-modal="true" aria-labelledby="leaderboard-modal-title">
      <button type="button" class="splash-modal-close" aria-label="Close">✕</button>
      <div class="leaderboard-top">
        <h2 id="leaderboard-modal-title">🏆 ALL-TIME LEADERBOARDS 🏆</h2>
        <div class="leaderboard-tabs" id="leaderboard-tabs">
          <button type="button" class="leaderboard-tab is-active" data-category="daily"><span class="leaderboard-tab-icon">🗓️</span><span class="leaderboard-tab-label">Daily</span></button>
          <button type="button" class="leaderboard-tab" data-category="community"><span class="leaderboard-tab-icon">🌎</span><span class="leaderboard-tab-label">Community</span></button>
          <button type="button" class="leaderboard-tab" data-category="unlimited"><span class="leaderboard-tab-icon">♾️</span><span class="leaderboard-tab-label">Unlimited</span></button>
          <button type="button" class="leaderboard-tab" data-category="created"><span class="leaderboard-tab-icon">✍️</span><span class="leaderboard-tab-label">Creators</span></button>
        </div>
        <div class="leaderboard-score-tabs" id="leaderboard-score-tabs">
          <button type="button" class="leaderboard-score-tab is-active" data-metric="total">Total Score</button>
          <button type="button" class="leaderboard-score-tab" data-metric="avg">Average Score</button>
        </div>
        <div class="leaderboard-score-tabs is-three-col hidden" id="leaderboard-created-tabs">
          <button type="button" class="leaderboard-score-tab is-active" data-metric="total">Total Made</button>
          <button type="button" class="leaderboard-score-tab" data-metric="karma">Karma</button>
          <button type="button" class="leaderboard-score-tab" data-metric="players">Players</button>
        </div>
      </div>
      <div class="leaderboard-list" id="leaderboard-list">
        <p class="leaderboard-coming-soon">Loading leaderboard...</p>
      </div>
      <div class="leaderboard-pagination" id="leaderboard-pagination">
        <div class="leaderboard-self" id="leaderboard-self-row"></div>
        <div class="leaderboard-page-controls">
          <button type="button" class="leaderboard-page-btn" id="leaderboard-prev-btn">◀  Prev</button>
          <span class="leaderboard-page-meta" id="leaderboard-page-meta">Page 1 / 1</span>
          <button type="button" class="leaderboard-page-btn" id="leaderboard-next-btn">Next  ▶</button>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(modalOverlay);

  const modalCard = modalOverlay.querySelector(".splash-modal-card") as HTMLDivElement | null;
  const closeButton = modalOverlay.querySelector(".splash-modal-close") as HTMLButtonElement | null;

  modalOverlay.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  closeButton?.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  modalCard?.addEventListener("click", (event) => {
    event.stopPropagation();
  });

  const tabs = modalOverlay.querySelectorAll(".leaderboard-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      const category = (tab.dataset.category ?? "daily") as LeaderboardCategory;
      leaderboardCategoryState = category;
      if (category === "created") {
        if (leaderboardMetricState !== "total" && leaderboardMetricState !== "karma" && leaderboardMetricState !== "players") {
          leaderboardMetricState = "total";
        }
      } else {
        if (leaderboardMetricState === "karma" || leaderboardMetricState === "players") {
          leaderboardMetricState = "total";
        }
      }
      leaderboardPageState = 1;
      setLeaderboardActiveTab(category);
      setLeaderboardScoreTabVisibility();
      setLeaderboardActiveScoreTab(leaderboardMetricState);
      setLeaderboardActiveCreatedTab(leaderboardMetricState);
      void loadLeaderboardModalData();
    });
  });

  const scoreTabs = modalOverlay.querySelectorAll("#leaderboard-score-tabs .leaderboard-score-tab") as NodeListOf<HTMLButtonElement>;
  scoreTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      if (leaderboardCategoryState === "created") return;
      const metric = (tab.dataset.metric ?? "total") as LeaderboardMetric;
      leaderboardMetricState = metric;
      leaderboardPageState = 1;
      setLeaderboardActiveScoreTab(metric);
      void loadLeaderboardModalData();
    });
  });

  const createdSortTabs = modalOverlay.querySelectorAll("#leaderboard-created-tabs .leaderboard-score-tab") as NodeListOf<HTMLButtonElement>;
  createdSortTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      if (leaderboardCategoryState !== "created") return;
      const metric = (tab.dataset.metric ?? "total") as LeaderboardMetric;
      leaderboardMetricState = metric;
      leaderboardPageState = 1;
      setLeaderboardActiveCreatedTab(metric);
      void loadLeaderboardModalData();
    });
  });

  const prevBtn = modalOverlay.querySelector("#leaderboard-prev-btn") as HTMLButtonElement | null;
  const nextBtn = modalOverlay.querySelector("#leaderboard-next-btn") as HTMLButtonElement | null;

  prevBtn?.addEventListener("click", () => {
    if (leaderboardPageState <= 1) return;
    leaderboardPageState -= 1;
    void loadLeaderboardModalData();
  });

  nextBtn?.addEventListener("click", () => {
    if (leaderboardPageState >= leaderboardTotalPagesState) return;
    leaderboardPageState += 1;
    void loadLeaderboardModalData();
  });
}

function setupArchiveModal() {
  if (document.getElementById(ARCHIVE_MODAL_ID)) {
    return;
  }

  const modalOverlay = document.createElement("div");
  modalOverlay.id = ARCHIVE_MODAL_ID;
  modalOverlay.className = "splash-modal-overlay hidden";
  modalOverlay.innerHTML = `
    <div class="splash-modal-card leaderboard-modal-card archive-modal-card" role="dialog" aria-modal="true" aria-labelledby="archive-modal-title">
      <button type="button" class="splash-modal-close" aria-label="Close">✕</button>
      <div class="leaderboard-top archive-top">
        <h2 id="archive-modal-title">🗂️ PUZZLE ARCHIVE 🗂️</h2>
        <div class="archive-tabs" id="archive-tabs">
          <button type="button" class="archive-tab is-active" data-category="all"><span class="leaderboard-tab-label">All</span></button>
          <button type="button" class="archive-tab" data-category="daily"><span class="leaderboard-tab-icon">🗓️</span><span class="leaderboard-tab-label">Daily</span></button>
          <button type="button" class="archive-tab" data-category="community"><span class="leaderboard-tab-icon">🌎</span><span class="leaderboard-tab-label">Community</span></button>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <span style="font-size: 0.8rem; color: rgb(255 255 255 / 65%); margin-bottom: -6px;">↕️</span>
          <div class="archive-sort-tabs" id="archive-sort-tabs">
          <button type="button" class="archive-sort-tab is-active" data-sort="date">🗓️ Date</button>
          <button type="button" class="archive-sort-tab" data-sort="players">👥 Players</button>
          <button type="button" class="archive-sort-tab" data-sort="avg">📊 Avg Score</button>
          <button type="button" class="archive-sort-tab" data-sort="karma"><span class="karma-arrow">▲</span> Upvotes</button>
        </div>
        </div>
        <div class="archive-options-row">
          <label class="archive-toggle-wrap archive-unplayed-wrap" for="archive-unplayed-toggle">
            <input type="checkbox" id="archive-unplayed-toggle" class="archive-toggle" />
            <span>Unplayed Only</span>
          </label>
          <details class="archive-more-options">
          <summary class="archive-more-summary">More options</summary>
          <div class="archive-more-body">
            <div class="archive-search-row">
              <input type="text" id="archive-title-input" class="archive-input" placeholder="Search by title ⌕" maxlength="80" />
              <input type="text" id="archive-author-input" class="archive-input" placeholder="Search by author ⌕" maxlength="40" />
            </div>
            <div class="archive-filter-row">
              <label class="archive-toggle-wrap" for="archive-nonstandard-toggle">
                <input type="checkbox" id="archive-nonstandard-toggle" class="archive-toggle" />
                <span>⚠️ Hide Non-Standard</span>
              </label>
              <select id="archive-size-select" class="archive-select">
                <option value="">Any Size</option>
                <option value="3">3x3</option>
                <option value="4">4x4</option>
                <option value="5">5x5</option>
                <option value="6">6x6</option>
                <option value="7">7x7</option>
                <option value="8plus">8x8+</option>
              </select>
              <button type="button" class="leaderboard-page-btn archive-filter-btn" id="archive-reset-btn">Reset</button>
            </div>
          </div>
          </details>
        </div>
      </div>
      <div class="leaderboard-list archive-list" id="archive-list">
        <p class="leaderboard-coming-soon">Loading archive...</p>
      </div>
      <div class="leaderboard-pagination archive-pagination" id="archive-pagination">
        <div class="leaderboard-self archive-summary" id="archive-summary-row"></div>
        <div class="leaderboard-page-controls">
          <button type="button" class="leaderboard-page-btn" id="archive-prev-btn">◀  Prev</button>
          <span class="leaderboard-page-meta" id="archive-page-meta">Page 1 / 1</span>
          <button type="button" class="leaderboard-page-btn" id="archive-next-btn">Next  ▶</button>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(modalOverlay);

  const modalCard = modalOverlay.querySelector(".splash-modal-card") as HTMLDivElement | null;
  const closeButton = modalOverlay.querySelector(".splash-modal-close") as HTMLButtonElement | null;

  modalOverlay.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  closeButton?.addEventListener("click", () => {
    modalOverlay.classList.add("hidden");
  });

  modalCard?.addEventListener("click", (event) => {
    event.stopPropagation();
  });

  const categoryTabs = modalOverlay.querySelectorAll(".archive-tab") as NodeListOf<HTMLButtonElement>;
  categoryTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      archiveCategoryState = (tab.dataset.category ?? "all") as ArchiveCategory;
      archivePageState = 1;
      setArchiveActiveCategory(archiveCategoryState);
      void loadArchiveModalData();
    });
  });

  const sortTabs = modalOverlay.querySelectorAll(".archive-sort-tab") as NodeListOf<HTMLButtonElement>;
  sortTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      archiveSortState = (tab.dataset.sort ?? "date") as ArchiveSort;
      archivePageState = 1;
      setArchiveActiveSort(archiveSortState);
      void loadArchiveModalData();
    });
  });

  const titleInput = modalOverlay.querySelector("#archive-title-input") as HTMLInputElement | null;
  const authorInput = modalOverlay.querySelector("#archive-author-input") as HTMLInputElement | null;
  const sizeSelect = modalOverlay.querySelector("#archive-size-select") as HTMLSelectElement | null;
  const nonStandardToggle = modalOverlay.querySelector("#archive-nonstandard-toggle") as HTMLInputElement | null;
  const unplayedToggle = modalOverlay.querySelector("#archive-unplayed-toggle") as HTMLInputElement | null;
  const resetBtn = modalOverlay.querySelector("#archive-reset-btn") as HTMLButtonElement | null;
  const prevBtn = modalOverlay.querySelector("#archive-prev-btn") as HTMLButtonElement | null;
  const nextBtn = modalOverlay.querySelector("#archive-next-btn") as HTMLButtonElement | null;

  const applyArchiveFilters = () => {
    archiveTitleState = titleInput?.value.trim() ?? "";
    archiveAuthorState = authorInput?.value.trim() ?? "";
    archiveSizeState = sizeSelect?.value ?? "";
    archiveNonStandardState = nonStandardToggle?.checked ? "standard" : "any";
    archiveUnplayedOnlyState = unplayedToggle?.checked ?? false;
    archivePageState = 1;
    void loadArchiveModalData();
  };

  let archiveFilterDebounce = 0;
  const scheduleArchiveFilterApply = () => {
    window.clearTimeout(archiveFilterDebounce);
    archiveFilterDebounce = window.setTimeout(() => {
      applyArchiveFilters();
    }, 220);
  };

  resetBtn?.addEventListener("click", () => {
    archiveCategoryState = "all";
    archiveSortState = "date";
    archivePageState = 1;
    archiveSizeState = "";
    archiveNonStandardState = "any";
    archiveUnplayedOnlyState = false;
    archiveAuthorState = "";
    archiveTitleState = "";
    if (titleInput) titleInput.value = "";
    if (authorInput) authorInput.value = "";
    if (sizeSelect) sizeSelect.value = "";
    if (nonStandardToggle) nonStandardToggle.checked = false;
    if (unplayedToggle) unplayedToggle.checked = false;
    setArchiveActiveCategory(archiveCategoryState);
    setArchiveActiveSort(archiveSortState);
    void loadArchiveModalData();
  });

  [titleInput, authorInput].forEach((input) => {
    input?.addEventListener("input", () => {
      scheduleArchiveFilterApply();
    });
    input?.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault();
        applyArchiveFilters();
      }
    });
  });

  sizeSelect?.addEventListener("change", () => {
    archiveSizeState = sizeSelect.value;
    archivePageState = 1;
    void loadArchiveModalData();
  });

  nonStandardToggle?.addEventListener("change", () => {
    archiveNonStandardState = nonStandardToggle.checked ? "standard" : "any";
    archivePageState = 1;
    void loadArchiveModalData();
  });

  unplayedToggle?.addEventListener("change", () => {
    archiveUnplayedOnlyState = unplayedToggle.checked;
    archivePageState = 1;
    void loadArchiveModalData();
  });

  prevBtn?.addEventListener("click", () => {
    if (archivePageState <= 1) return;
    archivePageState -= 1;
    void loadArchiveModalData();
  });

  nextBtn?.addEventListener("click", () => {
    if (archivePageState >= archiveTotalPagesState) return;
    archivePageState += 1;
    void loadArchiveModalData();
  });
}

function escapeHtml(v: unknown): string {
  return String(v ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function setLeaderboardActiveTab(category: LeaderboardCategory) {
  const tabs = document.querySelectorAll("#leaderboard-tabs .leaderboard-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.category === category);
  });
}

function setArchiveActiveCategory(category: ArchiveCategory) {
  const tabs = document.querySelectorAll("#archive-tabs .archive-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.category === category);
  });
}

function setArchiveActiveSort(sort: ArchiveSort) {
  const tabs = document.querySelectorAll("#archive-sort-tabs .archive-sort-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.sort === sort);
  });
}

function setLeaderboardActiveScoreTab(metric: LeaderboardMetric) {
  const tabs = document.querySelectorAll("#leaderboard-score-tabs .leaderboard-score-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.metric === metric);
  });
}

function setLeaderboardActiveCreatedTab(metric: LeaderboardMetric) {
  const tabs = document.querySelectorAll("#leaderboard-created-tabs .leaderboard-score-tab") as NodeListOf<HTMLButtonElement>;
  tabs.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.metric === metric);
  });
}

function setLeaderboardScoreTabVisibility() {
  const scoreTabs = document.getElementById("leaderboard-score-tabs");
  const createdTabs = document.getElementById("leaderboard-created-tabs");
  const isCreated = leaderboardCategoryState === "created";
  scoreTabs?.classList.toggle("hidden", isCreated);
  createdTabs?.classList.toggle("hidden", !isCreated);
}

function updateLeaderboardPaginationUi(page: number, totalPages: number) {
  const prevBtn = document.getElementById("leaderboard-prev-btn") as HTMLButtonElement | null;
  const nextBtn = document.getElementById("leaderboard-next-btn") as HTMLButtonElement | null;
  const meta = document.getElementById("leaderboard-page-meta") as HTMLSpanElement | null;

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

function updateArchivePaginationUi(page: number, totalPages: number) {
  const prevBtn = document.getElementById("archive-prev-btn") as HTMLButtonElement | null;
  const nextBtn = document.getElementById("archive-next-btn") as HTMLButtonElement | null;
  const meta = document.getElementById("archive-page-meta") as HTMLSpanElement | null;

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

function archiveCategoryLabel(category: string): string {
  if (category === "daily") return "🗓️ Daily";
  if (category === "community") return "🌎 Community";
  return "All";
}

function formatArchiveDate(value: string | undefined): string {
  if (!value) return "Unknown date";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Unknown date";
  return date.toLocaleDateString("en-US", {
    month: "numeric",
    day: "numeric",
    year: "2-digit",
  });
}

async function loadArchiveModalData() {
  const list = document.getElementById("archive-list") as HTMLDivElement | null;
  const summary = document.getElementById("archive-summary-row") as HTMLDivElement | null;
  const titleInput = document.getElementById("archive-title-input") as HTMLInputElement | null;
  const authorInput = document.getElementById("archive-author-input") as HTMLInputElement | null;
  const sizeSelect = document.getElementById("archive-size-select") as HTMLSelectElement | null;
  const nonStandardToggle = document.getElementById("archive-nonstandard-toggle") as HTMLInputElement | null;
  const unplayedToggle = document.getElementById("archive-unplayed-toggle") as HTMLInputElement | null;
  if (!list) return;

  if (titleInput && titleInput.value !== archiveTitleState) titleInput.value = archiveTitleState;
  if (authorInput && authorInput.value !== archiveAuthorState) authorInput.value = archiveAuthorState;
  if (sizeSelect && sizeSelect.value !== archiveSizeState) sizeSelect.value = archiveSizeState;
  if (nonStandardToggle) nonStandardToggle.checked = archiveNonStandardState === "standard";
  if (unplayedToggle) unplayedToggle.checked = archiveUnplayedOnlyState;

  list.innerHTML = `<p class="leaderboard-coming-soon">Loading archive...</p>`;

  try {
    const params = new URLSearchParams({
      page: String(archivePageState),
      limit: String(ARCHIVE_PAGE_SIZE),
      sort: archiveSortState,
      nonStandard: archiveNonStandardState,
      unplayedOnly: archiveUnplayedOnlyState ? "1" : "0",
    });
    if (archiveCategoryState !== "all") params.set("tag", archiveCategoryState);
    if (archiveSizeState) params.set("size", archiveSizeState);
    if (archiveAuthorState) params.set("author", archiveAuthorState);
    if (archiveTitleState) params.set("title", archiveTitleState);

    const res = await fetchWithTimeout(`/api/list-levels?${params.toString()}`);
    if (!res.ok) {
      list.innerHTML = `<p class="leaderboard-coming-soon">Could not load archive.</p>`;
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

    archivePageState = Math.max(1, Number(data.page ?? archivePageState));
    archiveTotalPagesState = Math.max(1, Number(data.totalPages ?? 1));
    updateArchivePaginationUi(archivePageState, archiveTotalPagesState);

    const puzzles = data.puzzles ?? [];
    if (puzzles.length === 0) {
      list.innerHTML = `
        <p class="leaderboard-coming-soon">No puzzles matched those filters.</p>
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
      const categoryLabel = archiveCategoryLabel(tagValue);
      const tagIcon = tagValue === "daily" ? "🗓️" : tagValue === "community" ? "🌎" : "🧩";
      const authorInline = tagValue === "daily" ? "" : `u/${escapeHtml(puzzle.levelCreator ?? "unknown")}`;
      const restMetaParts = [
        `<span class="archive-entry-inline-meta-date">${formatArchiveDate(puzzle.levelDate)}</span>`,
        `👥 ${totalPlayersLabel}`,
        `<span><span class="karma-arrow">▲</span> ${karma.toLocaleString()}</span>`,
      ];
      const restMeta = restMetaParts.join(" · ");
      const inlineMetaHtml = authorInline
        ? `<span class="archive-entry-author">${escapeHtml(authorInline)}</span><span class="archive-entry-inline-meta-rest"> · ${restMeta}</span>`
        : `<span class="archive-entry-inline-meta-rest">${restMeta}</span>`;
      const nonStandardInlineMeta = String(puzzle.nonStandard ?? "0") === "1"
        ? `<span class="archive-entry-inline-meta-rest"> · ⚠️NS</span>`
        : "";
      return `
        <article class="archive-entry" data-post-id="${escapeHtml(puzzle.postId)}">
          <span class="archive-played-pill ${puzzle.viewerPlayed ? "is-played" : "is-unplayed"}" aria-hidden="true"></span>
          <button type="button" class="archive-entry-toggle" data-post-id="${escapeHtml(puzzle.postId)}">
            <span class="archive-entry-copy">
              <span class="archive-entry-title-row">
                <span class="archive-entry-tag-icon" aria-hidden="true" title="${escapeHtml(categoryLabel)}">${tagIcon}</span>
                <span class="archive-entry-title">${escapeHtml(puzzle.levelName ?? "Untitled Puzzle")}</span>
              </span>
              <span class="archive-entry-inline-meta">${inlineMetaHtml}${nonStandardInlineMeta}<span class="archive-entry-meta-expand" role="button" tabindex="0" aria-label="Show puzzle details" aria-expanded="false">⋯</span></span>
            </span>
            <span class="archive-entry-caret">▶</span>
          </button>
          <div class="archive-entry-meta">
            <span class="archive-meta-pill">${categoryLabel}</span>
            <span class="archive-meta-pill">${sizeValue > 0 ? `${sizeValue}x${sizeValue}` : "Unknown size"}</span>
            <span class="archive-meta-pill">Avg Score: ${avgScoreLabel}</span>
            <span class="archive-meta-pill">${rulesLabel}</span>
          </div>
        </article>
      `;
    }).join("");

    const startRank = (archivePageState - 1) * ARCHIVE_PAGE_SIZE + 1;
    const endRank = startRank + puzzles.length - 1;
    const totalFiltered = Number(data.totalFiltered ?? puzzles.length);
    if (summary) {
      summary.textContent = `Showing ${startRank}-${endRank} of ${totalFiltered.toLocaleString()} puzzles`;
    }

    list.innerHTML = `
      <div class="leaderboard-head archive-head">
        <span>${totalFiltered.toLocaleString()} puzzles</span>
        <span>Sorted by ${archiveSortState === "avg" ? "avg score" : archiveSortState}</span>
      </div>
      <div class="archive-rows">${rows}</div>
    `;

    const toggleButtons = list.querySelectorAll(".archive-entry-toggle") as NodeListOf<HTMLButtonElement>;
    toggleButtons.forEach((button) => {
      button.addEventListener("click", () => {
        const selectedPostId = button.dataset.postId ?? "";
        if (!selectedPostId) return;
        navigateTo(archivePostUrl(selectedPostId));
      });
    });

    const metaToggles = list.querySelectorAll(".archive-entry-meta-expand") as NodeListOf<HTMLElement>;
    metaToggles.forEach((toggle) => {
      const entry = toggle.closest(".archive-entry") as HTMLElement | null;
      if (!entry) return;

      const setExpanded = (expanded: boolean) => {
        entry.classList.toggle("is-expanded", expanded);
        toggle.setAttribute("aria-expanded", String(expanded));
      };

      toggle.addEventListener("click", (event) => {
        event.preventDefault();
        event.stopPropagation();
        setExpanded(!entry.classList.contains("is-expanded"));
      });

      toggle.addEventListener("keydown", (event) => {
        if (event.key !== "Enter" && event.key !== " ") return;
        event.preventDefault();
        event.stopPropagation();
        setExpanded(!entry.classList.contains("is-expanded"));
      });
    });
  } catch (err) {
    console.error(err);
    list.innerHTML = `<p class="leaderboard-coming-soon">Could not load archive.</p>`;
    if (summary) summary.innerHTML = "";
  }
}

function medalForRank(rank: number): string {
  if (rank === 1) return "🥇";
  if (rank === 2) return "🥈";
  if (rank === 3) return "🥉";
  return "";
}

function leaderboardMetricLabel(category: LeaderboardCategory, metric: LeaderboardMetric): string {
  if (category === "created") {
    if (metric === "karma") return "Total Karma";
    if (metric === "players") return "Total Players";
    return "Puzzles Made";
  }
  return metric === "avg" ? "Average Score" : "Total Score";
}

function formatLeaderboardScore(value: number, category: LeaderboardCategory, metric: LeaderboardMetric): string {
  if (category !== "created" && metric === "avg") {
    return Number(value).toFixed(0);
  }
  return Number(value).toLocaleString();
}

async function loadLeaderboardModalData() {
  const list = document.getElementById("leaderboard-list") as HTMLDivElement | null;
  const selfRowEl = document.getElementById("leaderboard-self-row") as HTMLDivElement | null;
  if (!list) return;

  list.innerHTML = `<p class="leaderboard-coming-soon">Loading leaderboard...</p>`;
  if (selfRowEl) {
    selfRowEl.innerHTML = "";
  }

  try {
    const res = await fetchWithTimeout(
      `/api/leaderboard-alltime?category=${leaderboardCategoryState}&metric=${leaderboardMetricState}&limit=${LEADERBOARD_PAGE_SIZE}&page=${leaderboardPageState}`
    );
    if (!res.ok) {
      list.innerHTML = `<p class="leaderboard-coming-soon">Could not load leaderboard.</p>`;
      return;
    }

    const data = await res.json() as {
      entries?: Array<{ rank: number; username: string; score: number; playedCount?: number; searchUrl?: string }>;
      self?: { rank: number; username: string; score: number; playedCount?: number; searchUrl?: string } | null;
      totalPlayers?: number;
      page?: number;
      totalPages?: number;
      subredditName?: string;
      metric?: LeaderboardMetric;
    };

    leaderboardPageState = Math.max(1, Number(data.page ?? leaderboardPageState));
    leaderboardTotalPagesState = Math.max(1, Number(data.totalPages ?? 1));
    updateLeaderboardPaginationUi(leaderboardPageState, leaderboardTotalPagesState);

    const entries = data.entries ?? [];
    if (entries.length === 0) {
      list.innerHTML = `<p class="leaderboard-coming-soon">No ranked players yet for this category.</p>`;
      if (selfRowEl) {
        selfRowEl.innerHTML = `Your Rank: <b>Unranked</b>`;
      }
      return;
    }

    const rows = entries
      .map((entry) => {
        const isSelf = entry.username === (context.username ?? "");
        const medal = medalForRank(entry.rank);
        const topRankClass = entry.rank === 1
          ? "is-rank-1"
          : entry.rank === 2
            ? "is-rank-2"
            : entry.rank === 3
              ? "is-rank-3"
              : "";
        const profileLink = leaderboardCategoryState === "created"
          ? `<button type="button" class="lb-user-link" data-author="${escapeHtml(entry.username)}">u/${escapeHtml(entry.username)} <span class="lb-link-emoji">🔍</span></button>`
          : `u/${escapeHtml(entry.username)}`;
        const playedCountMarkup = leaderboardCategoryState !== "created"
          ? ` <span class="lb-score-meta">(${Number(entry.playedCount ?? 0).toLocaleString()})</span>`
          : "";
        return `<div class="leaderboard-row ${isSelf ? "is-self" : ""} ${topRankClass}">
          <span class="lb-rank">${medal ? `${medal} ` : ""}#${entry.rank}</span>
          <span class="lb-user">${profileLink}${isSelf ? ' <span class="lb-you">(You)</span>' : ""}</span>
          <span class="lb-score">${formatLeaderboardScore(entry.score, leaderboardCategoryState, leaderboardMetricState)}${playedCountMarkup}</span>
        </div>`;
      })
      .join("");

    const metricLabel = leaderboardMetricLabel(leaderboardCategoryState, leaderboardMetricState);
    const selfPlayedCount = leaderboardCategoryState !== "created"
      ? ` <span class="lb-score-meta">(${Number(data.self?.playedCount ?? 0).toLocaleString()})</span>`
      : "";
    const selfContent = data.self
      ? `Your Rank: <b>#${data.self.rank}</b> • ${metricLabel}: <b>${formatLeaderboardScore(data.self.score, leaderboardCategoryState, leaderboardMetricState)}${selfPlayedCount}</b>`
      : `Your Rank: <b>Unranked</b>`;
    if (selfRowEl) selfRowEl.innerHTML = selfContent;

    const rankStart = (leaderboardPageState - 1) * LEADERBOARD_PAGE_SIZE + 1;
    const rankEnd = rankStart + entries.length - 1;
    const isCreatedCategory = leaderboardCategoryState === "created";
    const rankLabel = leaderboardPageState === 1 && entries.length <= LEADERBOARD_PAGE_SIZE
      ? `Top ${entries.length}${isCreatedCategory ? " Creators" : ""}`
      : `Ranks ${rankStart}–${rankEnd}`;
    const rankedLabel = isCreatedCategory ? "creators ranked" : "players ranked";
    const explainer = isCreatedCategory
      ? `<p class="leaderboard-explainer">Tap a username to browse their puzzles in the archive.</p>`
      : leaderboardMetricState === "avg"
        ? `<p class="leaderboard-explainer">Must complete at least 5 puzzles to get ranked</p>`
        : "";
    list.innerHTML = `
      ${explainer}
      <div class="leaderboard-head">
        <span>${rankLabel}</span>
        <span>${(data.totalPlayers ?? entries.length).toLocaleString()} ${rankedLabel}</span>
      </div>
      <div class="leaderboard-rows">${rows}</div>
    `;

    const userLinkButtons = list.querySelectorAll(".lb-user-link") as NodeListOf<HTMLButtonElement>;
    userLinkButtons.forEach((btn) => {
      btn.addEventListener("click", () => {
        const author = btn.dataset.author;
        if (!author) return;
        document.getElementById(LEADERBOARD_MODAL_ID)?.classList.add("hidden");
        openArchiveModalWithAuthor(author);
      });
    });
  } catch (err) {
    console.error(err);
    list.innerHTML = `<p class="leaderboard-coming-soon">Could not load leaderboard.</p>`;
    if (selfRowEl) {
      selfRowEl.innerHTML = "";
    }
  }
}

function statValue(v: unknown): string {
  if (v === undefined || v === null || String(v).trim() === "") return "0";
  return String(v);
}

function toNum(v: unknown): number {
  const n = Number(v ?? 0);
  return Number.isFinite(n) ? n : 0;
}

function formatAvg(value: number): string {
  return Number.isFinite(value) ? value.toFixed(1) : "0.0";
}

function formatPerc(n: number): string {
  return `${Math.round(n)}%`;
}

function buildModeStats(data: Record<string, unknown>, prefix: "d" | "c" | "u") {
  const started = toNum(data[`stat_${prefix}_total_started`]);
  const finished = toNum(data[`stat_${prefix}_total_finished`]);
  const totalGuesses = toNum(data[`stat_${prefix}_total_guesses`]);
  const totalTime = toNum(data[`stat_${prefix}_total_time`]);
  const totalScore = toNum(data[`stat_${prefix}_total_score`]);
  const denom = finished > 0 ? finished : 0;

  return {
    played: String(started),
    finished: formatPerc(started > 0 ? (finished / started) * 100 : 0),
    avgGuesses: denom > 0 ? formatAvg(totalGuesses / denom) : "0.0",
    avgTime: denom > 0 ? formatTimeFromSteps(totalTime / denom) : "0:00",
    avgScore: denom > 0 ? String(Math.round(totalScore / denom)) : "0",
  };
}

async function loadProfileModalData() {
  const body = document.getElementById("profile-modal-body") as HTMLDivElement | null;
  const usernameEl = document.getElementById("profile-modal-username") as HTMLParagraphElement | null;
  if (!body) return;

  body.innerHTML = `<p class="profile-loading">Loading stats...</p>`;

  try {
    const res = await fetchWithTimeout("/api/profile");
    if (!res.ok) {
      body.innerHTML = `<p class="profile-loading">Could not load profile stats.</p>`;
      return;
    }

    const d = await res.json() as Record<string, unknown>;
    const uname = statValue(d.username || context.username || "player");
    const subredditName = String(context.subredditName ?? "Sneakle");
    const puzzleSearchUrl = `https://www.reddit.com/r/${encodeURIComponent(subredditName)}/search/?q=author%3A${encodeURIComponent(uname)}`;

    if (usernameEl) {
      usernameEl.textContent = `u/${uname}`;
    }

    const daily = buildModeStats(d, "d");
    const community = buildModeStats(d, "c");
    const unlimited = buildModeStats(d, "u");
    const createdTotal = statValue(d.created_total);

    const statsBlock = (title: string, s: { played: string; finished: string; avgGuesses: string; avgTime: string; avgScore: string; }) => `
      <div class="profile-stat-block">
        <h3>${title}</h3>
        <div class="profile-stat-grid">
          <div><span>played</span><b>${s.played}</b></div>
          <div><span>finished</span><b>${s.finished}</b></div>
          <div><span>avg guesses</span><b>${s.avgGuesses}</b></div>
          <div><span>avg time</span><b>${s.avgTime}</b></div>
          <div><span>avg score</span><b>${s.avgScore}</b></div>
        </div>
      </div>
    `;

    const createdBlock = `
      <div class="profile-stat-block">
        <h3>✍️ Created</h3>
        <div class="profile-stat-grid">
          <div><span>puzzles made</span><b>${createdTotal}</b></div>
        </div>
        <div class="profile-created-actions">
          <button type="button" class="profile-puzzle-btn" data-url="${escapeHtml(puzzleSearchUrl)}">See All Your Puzzles <span class="lb-link-emoji">🔗</span></button>
        </div>
      </div>
    `;

    body.innerHTML = `
      ${statsBlock("🗓️ Daily", daily)}
      ${statsBlock("🌎 Community", community)}
      ${statsBlock("♾️ Unlimited", unlimited)}
      ${createdBlock}
    `;

    const profilePuzzleBtn = body.querySelector(".profile-puzzle-btn") as HTMLButtonElement | null;
    profilePuzzleBtn?.addEventListener("click", () => {
      const url = profilePuzzleBtn.dataset.url;
      if (!url) return;
      navigateTo(url);
    });
  } catch (err) {
    console.error(err);
    body.innerHTML = `<p class="profile-loading">Could not load profile stats.</p>`;
  }
}

function openProfileModal() {
  setupProfileModal();
  void loadProfileModalData();
  const modalOverlay = document.getElementById(PROFILE_MODAL_ID);
  if (modalOverlay) {
    modalOverlay.classList.remove("hidden");
  }
}

function openLeaderboardModal() {
  setupLeaderboardModal();
  leaderboardCategoryState = "daily";
  leaderboardMetricState = "total";
  leaderboardPageState = 1;
  leaderboardTotalPagesState = 1;
  setLeaderboardActiveTab(leaderboardCategoryState);
  setLeaderboardScoreTabVisibility();
  setLeaderboardActiveScoreTab(leaderboardMetricState);
  updateLeaderboardPaginationUi(1, 1);
  void loadLeaderboardModalData();
  const modalOverlay = document.getElementById(LEADERBOARD_MODAL_ID);
  if (modalOverlay) {
    modalOverlay.classList.remove("hidden");
  }
}

function openArchiveModal() {
  setupArchiveModal();
  archiveCategoryState = "all";
  archiveSortState = "date";
  archivePageState = 1;
  archiveTotalPagesState = 1;
  archiveSizeState = "";
  archiveNonStandardState = "any";
  archiveUnplayedOnlyState = false;
  archiveAuthorState = "";
  archiveTitleState = "";
  setArchiveActiveCategory(archiveCategoryState);
  setArchiveActiveSort(archiveSortState);
  updateArchivePaginationUi(1, 1);
  void loadArchiveModalData();
  const modalOverlay = document.getElementById(ARCHIVE_MODAL_ID);
  if (modalOverlay) {
    modalOverlay.classList.remove("hidden");
  }
}

function openArchiveModalWithAuthor(author: string) {
  setupArchiveModal();
  archiveCategoryState = "all";
  archiveSortState = "date";
  archivePageState = 1;
  archiveTotalPagesState = 1;
  archiveSizeState = "";
  archiveNonStandardState = "any";
  archiveUnplayedOnlyState = false;
  archiveTitleState = "";
  archiveAuthorState = author;
  setArchiveActiveCategory(archiveCategoryState);
  setArchiveActiveSort(archiveSortState);
  updateArchivePaginationUi(1, 1);
  const authorInput = document.getElementById("archive-author-input") as HTMLInputElement | null;
  if (authorInput) authorInput.value = author;
  const moreOptions = document.querySelector(".archive-more-options") as HTMLDetailsElement | null;
  if (moreOptions) moreOptions.open = true;
  void loadArchiveModalData();
  const modalOverlay = document.getElementById(ARCHIVE_MODAL_ID);
  modalOverlay?.classList.remove("hidden");
}

function initSplashExtraModals() {
  if (document.getElementById("profile-modal-btn")) {
    return;
  }

  const actionRow = document.createElement("div");
  actionRow.className = "splash-modal-actions";
  actionRow.innerHTML = `
    <button type="button" id="leaderboard-modal-btn" class="splash-mini-btn" aria-label="Open leaderboard" title="Leaderboard">🏆<span class="mini-btn-label">Leaderboard</span></button>
    <button type="button" id="archive-modal-btn" class="splash-mini-btn" aria-label="Open archive" title="Archive">🗂️<span class="mini-btn-label">Archive</span></button>
    <button type="button" id="profile-modal-btn" class="splash-mini-btn" aria-label="Open profile stats" title="Profile Stats">📊<span class="mini-btn-label">Stats</span></button>
  `;

  const topRightControls = document.getElementById("top-right-controls");
  if (topRightControls) {
    topRightControls.appendChild(actionRow);
  } else {
    document.body.appendChild(actionRow);
  }

  const archiveBtn = document.getElementById("archive-modal-btn") as HTMLButtonElement | null;
  const profileBtn = document.getElementById("profile-modal-btn") as HTMLButtonElement | null;
  const leaderboardBtn = document.getElementById("leaderboard-modal-btn") as HTMLButtonElement | null;

  archiveBtn?.addEventListener("click", () => {
    openArchiveModal();
  });

  profileBtn?.addEventListener("click", () => {
    openProfileModal();
  });

  leaderboardBtn?.addEventListener("click", () => {
    openLeaderboardModal();
  });
}

function shouldUseLowMotionMode(): boolean {
  return false;
}

function initPerformanceMode() {
  const hydratePreviewSources = () => {
    if (!previewVideo) {
      return;
    }

    const sourceEls = Array.from(previewVideo.querySelectorAll("source")) as HTMLSourceElement[];
    const hasHydratedSource = sourceEls.some((sourceEl) => Boolean(sourceEl.getAttribute("src")));

    if (hasHydratedSource) {
      return;
    }

    for (const sourceEl of sourceEls) {
      const src = sourceEl.dataset.src;
      if (src) {
        sourceEl.src = src;
      }
    }

    previewVideo.load();
  };

  const clearPreviewSources = () => {
    if (!previewVideo) {
      return;
    }

    previewVideo.pause();

    const sourceEls = Array.from(previewVideo.querySelectorAll("source")) as HTMLSourceElement[];
    for (const sourceEl of sourceEls) {
      sourceEl.removeAttribute("src");
    }

    previewVideo.load();
  };

  const playPreviewIfAllowed = () => {
    if (!previewVideo) {
      return;
    }

    previewVideo.muted = true;
    previewVideo.defaultMuted = true;
    previewVideo.playsInline = true;

    void previewVideo.play().catch(() => {
      // Some environments can still block autoplay despite muted+inline.
    });
  };

  const update = () => {
    const useLowMotion = shouldUseLowMotionMode();
    document.body.classList.toggle("low-motion", useLowMotion);

    if (!previewVideo) {
      return;
    }

    if (useLowMotion) {
      clearPreviewSources();
    } else {
      hydratePreviewSources();
      playPreviewIfAllowed();
    }
  };

  update();
  document.addEventListener("visibilitychange", update);
}

async function fetchWithTimeout(input: RequestInfo | URL, init: RequestInit = {}, timeoutMs = API_TIMEOUT_MS): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = window.setTimeout(() => controller.abort(), timeoutMs);

  try {
    return await fetch(input, {
      ...init,
      signal: controller.signal,
      cache: "no-store",
    });
  } finally {
    window.clearTimeout(timeoutId);
  }
}


function initTitle() {

  titleElement.innerHTML = `
    <span>Hey <b>${context.username ?? "you"}</b>, can you find the <i>hidden word?</i></span>
  `;

  startButton.innerHTML = "<span class='span-play-icon'>▶</span>Let's Play!"
}

initTitle();
initPerformanceMode();
initSplashExtraModals();

function initDebugButton() {
  const username = context.username ?? "";
  const isDebugUser = DEBUG_USERS.has(username);

  if (!debugButton || !debugButtonWrapper || !isDebugUser) {
    return;
  }

  debugButtonWrapper.hidden = false;
  debugButton.addEventListener("click", () => {
    window.location.href = DEBUG_PAGE_PATH;
  });
}

initDebugButton();


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
  levelTagElement.classList.remove("nonStandard");
  contentElement?.classList.remove("tag-community-shell");

  if (rawTag === "community") {
    contentElement?.classList.add("tag-community-shell");
  }

  if (postData?.nonStandard) {
    if (postData?.nonStandard === "1") {
      levelTagElement.classList.add("nonStandard");
      levelTagElement.innerHTML = `<b>${levelTagStr || "-"}</b><button type="button" class="nonstandard-pill" id="nonstandard-pill" aria-label="What does NON-STANDARD mean?">⚠️NON-STANDARD!ℹ️</button>`;

      const nonStandardPillButton = document.getElementById("nonstandard-pill") as HTMLButtonElement | null;
      nonStandardPillButton?.addEventListener("click", () => {
        openNonStandardModal();
      });
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

  // makePuzzlePrevHTML();



}


async function initIsCreatePost() {

  let thisIsCreatePost = false

  try {
    const createPostRes = await fetchWithTimeout("/api/get-create-post");

    if (createPostRes.ok) {
      const createPostData = await createPostRes.json();

      if (createPostData?.id === postId) {

        thisIsCreatePost = true

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
  try {
    const res = await fetchWithTimeout(`/api/state?postId=${postId}`);

    if (!res.ok) {
      return;
    }

    const userData = await res.json();

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
  } catch (err) {
    console.error(err);
  }
}



/* JOIN BUTTON STUFF */

const joinButton = document.getElementById("join-button") as HTMLButtonElement | null;
const joinButtonWrapper = document.getElementById("join-button-wrapper") as HTMLDivElement | null;

function hideJoinButton() {
  joinButtonWrapper?.classList.remove("wiggle-intermittent");
  joinButtonWrapper?.setAttribute("hidden", "true");
}

joinButton?.addEventListener("click", async () => {
  try {
    const res = await fetch("/api/join-subreddit", { method: "POST" });

    if (res.ok) {
      showToast("Joined r/Sneakle!");
      if (joinButton) {
        joinButton.textContent = "Joined 💖";
        joinButton.disabled = true;
      }
      hideJoinButton();
    }
  } catch (err) {
    console.error(err);
  }
});

async function checkSubscription() {
  try {
    const res = await fetchWithTimeout("/api/subscription-status");

    if (!res.ok) {
      return;
    }

    const data = await res.json();

    if (data.subscribed) {
      if (joinButton) {
        joinButton.textContent = "Joined 💖";
        joinButton.disabled = true;
      }
      hideJoinButton();
    }
  } catch (err) {
    console.error(err);
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
        // Render baseline splash immediately, then run network calls in parallel.
        await initSplash();
        await Promise.allSettled([
          initIsCreatePost(),
          checkSubscription(),
          initUserState(),
        ]);
        
    } catch (error) {
        console.error("An error occurred:", error);
    }
};

initSequentially();

