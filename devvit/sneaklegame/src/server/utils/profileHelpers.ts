import { context, reddit, redis } from "@devvit/web/server";

export const PROFILE_FIELD_DEFINITIONS = [
  { name: "stat_d_total_started", label: "Daily Started", defaultValue: "0" },
  { name: "stat_d_total_finished", label: "Daily Finished", defaultValue: "0" },
  { name: "stat_d_total_gaveup", label: "Daily Gave Up", defaultValue: "0" },
  { name: "stat_d_total_score", label: "Daily Total Score", defaultValue: "0" },
  { name: "stat_d_total_time", label: "Daily Total Time", defaultValue: "0" },
  { name: "stat_d_total_guesses", label: "Daily Total Guesses", defaultValue: "0" },
  { name: "stat_d_total_hints", label: "Daily Total Hints", defaultValue: "0" },
  { name: "stat_c_total_started", label: "Community Started", defaultValue: "0" },
  { name: "stat_c_total_finished", label: "Community Finished", defaultValue: "0" },
  { name: "stat_c_total_gaveup", label: "Community Gave Up", defaultValue: "0" },
  { name: "stat_c_total_score", label: "Community Total Score", defaultValue: "0" },
  { name: "stat_c_total_time", label: "Community Total Time", defaultValue: "0" },
  { name: "stat_c_total_guesses", label: "Community Total Guesses", defaultValue: "0" },
  { name: "stat_c_total_hints", label: "Community Total Hints", defaultValue: "0" },
  { name: "stat_u_total_started", label: "Unlimited Started", defaultValue: "0" },
  { name: "stat_u_total_finished", label: "Unlimited Finished", defaultValue: "0" },
  { name: "stat_u_total_gaveup", label: "Unlimited Gave Up", defaultValue: "0" },
  { name: "stat_u_total_score", label: "Unlimited Total Score", defaultValue: "0" },
  { name: "stat_u_total_time", label: "Unlimited Total Time", defaultValue: "0" },
  { name: "stat_u_total_guesses", label: "Unlimited Total Guesses", defaultValue: "0" },
  { name: "stat_u_total_hints", label: "Unlimited Total Hints", defaultValue: "0" },
  { name: "created_total", label: "Created Total", defaultValue: "0" },
  { name: "created_ids", label: "Created Post IDs (comma separated)", defaultValue: "-1" },
  { name: "created_karma", label: "Created Total Karma", defaultValue: "0" },
  { name: "created_players", label: "Created Total Players", defaultValue: "0" },
  { name: "option_darkmode", label: "Option Darkmode", defaultValue: "1" },
  { name: "option_sfx", label: "Option SFX", defaultValue: "1" },
  { name: "option_show_timer", label: "Option Show Timer", defaultValue: "1" },
  { name: "profile_joined", label: "Profile Joined Subreddit", defaultValue: "0" },
  { name: "nonstandard_tut_seen", label: "Non-Standard Tutorial Seen", defaultValue: "0" },
] as const;

export type ProfileFieldName = (typeof PROFILE_FIELD_DEFINITIONS)[number]["name"];
export type EditableProfileData = Partial<Record<ProfileFieldName, string>>;

type StoredUserProfile = {
  username?: string;
  updatedBy?: string;
  updatedAt?: string;
  profileData?: Record<string, string>;
};

type AllTimeCategory = "daily" | "community" | "unlimited" | "created";
type AllTimeMetric = "total" | "avg";
const MIN_FINISHED_FOR_AVG_LEADERBOARD = 5;

function allTimeLeaderboardKey(category: AllTimeCategory, metric: AllTimeMetric) {
  return `lb:alltime:${category}:${metric}`;
}

function toNum(value: string | undefined): number {
  const n = Number(value ?? "0");
  return Number.isFinite(n) ? n : 0;
}

function shouldSyncScoreCategory(
  prevScoreRaw: string | undefined,
  nextScoreRaw: string | undefined,
  prevFinishedRaw: string | undefined,
  nextFinishedRaw: string | undefined
): boolean {
  const prevScore = String(prevScoreRaw ?? "0");
  const nextScore = String(nextScoreRaw ?? "0");
  if (prevScore !== nextScore) {
    return true;
  }

  const prevFinished = toNum(prevFinishedRaw);
  const nextFinished = toNum(nextFinishedRaw);
  const finishedChanged = prevFinished !== nextFinished;
  const touchesAvgEligibility = prevFinished >= MIN_FINISHED_FOR_AVG_LEADERBOARD || nextFinished >= MIN_FINISHED_FOR_AVG_LEADERBOARD;

  return finishedChanged && touchesAvgEligibility;
}

async function syncAllTimeLeaderboardCategories(
  username: string,
  profileData: Record<string, string>,
  categories: AllTimeCategory[]
) {
  for (const category of categories) {
    if (category === "daily") {
      const total = toNum(profileData.stat_d_total_score);
      const finished = toNum(profileData.stat_d_total_finished);
      const avg = finished > 0 ? total / finished : 0;
      await redis.zAdd(allTimeLeaderboardKey("daily", "total"), { score: total, member: username });
      if (finished >= MIN_FINISHED_FOR_AVG_LEADERBOARD) {
        await redis.zAdd(allTimeLeaderboardKey("daily", "avg"), { score: avg, member: username });
      } else {
        await redis.zRem(allTimeLeaderboardKey("daily", "avg"), [username]);
      }
      continue;
    }

    if (category === "community") {
      const total = toNum(profileData.stat_c_total_score);
      const finished = toNum(profileData.stat_c_total_finished);
      const avg = finished > 0 ? total / finished : 0;
      await redis.zAdd(allTimeLeaderboardKey("community", "total"), { score: total, member: username });
      if (finished >= MIN_FINISHED_FOR_AVG_LEADERBOARD) {
        await redis.zAdd(allTimeLeaderboardKey("community", "avg"), { score: avg, member: username });
      } else {
        await redis.zRem(allTimeLeaderboardKey("community", "avg"), [username]);
      }
      continue;
    }

    if (category === "unlimited") {
      const total = toNum(profileData.stat_u_total_score);
      const finished = toNum(profileData.stat_u_total_finished);
      const avg = finished > 0 ? total / finished : 0;
      await redis.zAdd(allTimeLeaderboardKey("unlimited", "total"), { score: total, member: username });
      if (finished >= MIN_FINISHED_FOR_AVG_LEADERBOARD) {
        await redis.zAdd(allTimeLeaderboardKey("unlimited", "avg"), { score: avg, member: username });
      } else {
        await redis.zRem(allTimeLeaderboardKey("unlimited", "avg"), [username]);
      }
      continue;
    }

    if (category === "created") {
      const total = toNum(profileData.created_total);
      await redis.zAdd(allTimeLeaderboardKey("created", "total"), { score: total, member: username });
      const karma = toNum(profileData.created_karma);
      await redis.zAdd("lb:alltime:created:karma", { score: karma, member: username });
      const players = toNum(profileData.created_players);
      await redis.zAdd("lb:alltime:created:players", { score: players, member: username });
    }
  }
}

function userProfileKey(username: string) {
  return `profile:${username}`;
}

function getProfileDefaults(): Record<ProfileFieldName, string> {
  return PROFILE_FIELD_DEFINITIONS.reduce((acc, field) => {
    acc[field.name] = field.defaultValue;
    return acc;
  }, {} as Record<ProfileFieldName, string>);
}

function getProfileData(profile: StoredUserProfile | null): Record<ProfileFieldName, string> {
  const defaults = getProfileDefaults();

  for (const field of PROFILE_FIELD_DEFINITIONS) {
    const rawValue = profile?.profileData?.[field.name];
    if (rawValue !== undefined && rawValue !== null) {
      defaults[field.name] = String(rawValue);
    }
  }

  return defaults;
}

async function updateUserFlairIfNeeded(username: string, profileData: Record<string, string>) {
  if (!Object.prototype.hasOwnProperty.call(profileData, "stat_d_total_score")) {
    return;
  }

  try {
    let flairTextStart = "";
    let flairBGColor = "#36C95D";

    if (Number(profileData.created_total ?? "0") >= 1) {
      flairTextStart = "Puzzle Maker 🔠✏️";
      flairBGColor = "#DD8F22";
    } else {
      flairTextStart = "Sneakler 🔠";
      flairBGColor = "#36C95D";
    }

    const flairText = `${flairTextStart} - Total Score: ${profileData.stat_d_total_score ?? "0"}`;

    console.log(`flairText = ${flairText}`);

    if (username === "FermenterGames") {
      console.log(`Flair update SKIPPED for user: ${username}`);
      return;
    }

    await reddit.setUserFlair({
      subredditName: `${context.subredditName}`,
      username,
      text: flairText,
      backgroundColor: flairBGColor,
      textColor: "dark",
    });

    console.log(`Flair updated for user: ${username}`);
  } catch (error) {
    console.error(`Failed to set flair for user: ${username} --`, error);
  }
}

export async function getUserProfile(username: string): Promise<StoredUserProfile | null> {
  const raw = await redis.get(userProfileKey(username));
  return raw ? (JSON.parse(raw) as StoredUserProfile) : null;
}

export function buildProfileResponse(username: string, profile: StoredUserProfile | null) {
  return {
    type: "profile",
    ...getProfileData(profile),
    username,
  };
}

export function buildProfileEditorFields(username: string, profile: StoredUserProfile | null) {
  const values = getProfileData(profile);

  return [
    {
      type: "string",
      name: "username",
      label: "Username - DON'T CHANGE",
      defaultValue: username,
      hidden: true,
    },
    ...PROFILE_FIELD_DEFINITIONS.map((field) => ({
      type: "string",
      name: field.name,
      label: field.label,
      defaultValue: values[field.name],
    })),
  ];
}

export function extractProfileDataFromForm(values: Record<string, unknown>): EditableProfileData {
  return PROFILE_FIELD_DEFINITIONS.reduce((acc, field) => {
    const rawValue = values[field.name];
    acc[field.name] = rawValue === undefined || rawValue === null
      ? field.defaultValue
      : String(rawValue);
    return acc;
  }, {} as EditableProfileData);
}

export async function saveUserProfile({
  username,
  profileData,
  updatedBy,
}: {
  username: string;
  profileData: Record<string, string>;
  updatedBy?: string;
}): Promise<StoredUserProfile> {
  const key = userProfileKey(username);
  const prevRaw = await redis.get(key);
  const prev = prevRaw ? (JSON.parse(prevRaw) as StoredUserProfile) : {};

  const next: StoredUserProfile = {
    ...prev,
    profileData: {
      ...(prev.profileData ?? {}),
      ...profileData,
    },
    username,
    updatedBy: updatedBy || username || "anonymous",
    updatedAt: new Date().toISOString(),
  };

  const prevProfileData = prev.profileData ?? {};
  const nextProfileData = next.profileData ?? {};
  const categoriesToSync: AllTimeCategory[] = [];

  if (shouldSyncScoreCategory(
    prevProfileData.stat_d_total_score,
    nextProfileData.stat_d_total_score,
    prevProfileData.stat_d_total_finished,
    nextProfileData.stat_d_total_finished,
  )) {
    categoriesToSync.push("daily");
  }
  if (shouldSyncScoreCategory(
    prevProfileData.stat_c_total_score,
    nextProfileData.stat_c_total_score,
    prevProfileData.stat_c_total_finished,
    nextProfileData.stat_c_total_finished,
  )) {
    categoriesToSync.push("community");
  }
  if (shouldSyncScoreCategory(
    prevProfileData.stat_u_total_score,
    nextProfileData.stat_u_total_score,
    prevProfileData.stat_u_total_finished,
    nextProfileData.stat_u_total_finished,
  )) {
    categoriesToSync.push("unlimited");
  }
  if (
    String(prevProfileData.created_total ?? "0") !== String(nextProfileData.created_total ?? "0") ||
    String(prevProfileData.created_karma ?? "0") !== String(nextProfileData.created_karma ?? "0") ||
    String(prevProfileData.created_players ?? "0") !== String(nextProfileData.created_players ?? "0")
  ) {
    if (!categoriesToSync.includes("created")) {
      categoriesToSync.push("created");
    }
  }

  await redis.set(key, JSON.stringify(next));
  await updateUserFlairIfNeeded(username, next.profileData ?? {});
  if (categoriesToSync.length > 0) {
    await syncAllTimeLeaderboardCategories(username, nextProfileData, categoriesToSync);
  }

  return next;
}