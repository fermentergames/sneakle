import { Hono } from "hono";
import { reddit, redis } from "@devvit/web/server";
import { Logger } from "./utils/Logger";
import {
    DebugRedisType,
    KeyCatalogItemDto,
    KeyCatalogResponseDto,
    KeyDebugRequestDto,
    KeyDebugResponseDto,
} from "../shared/debugTypes";

const DEBUG_USERS = new Set(["FermenterGames"]);
const DEFAULT_ZSET_COUNT = 200;

const FIXED_SYSTEM_KEYS = [
    "createPost",
    "createPostID",
    "createPostURL",
    "dailyCount",
    "dailyList",
    "globalStats:puzzlesCreatedTotal",
    "job:cancel:job-resync-batch-user-profiles",
    "job:cancel:job-resync-created-karma",
    "job:cancel:job-resync-single-user-profile",
    "job:resyncCreatedKarma",
    "job:resyncProfiles",
    "lb:alltime:community:avg",
    "lb:alltime:community:total",
    "lb:alltime:created:karma",
    "lb:alltime:created:players",
    "lb:alltime:created:total",
    "lb:alltime:daily:avg",
    "lb:alltime:daily:total",
    "lb:alltime:unlimited:avg",
    "lb:alltime:unlimited:total",
    "levelCount",
    "levelList",
    "puzzles:enabled",
    "puzzles:queue",
];

function zRangeMembers(values: Array<string | { member: string; score: number }>): string[] {
    return values.map((value) => (typeof value === "string" ? value : value.member));
}

function toRedisType(value: string): DebugRedisType {
    switch (value) {
        case "string":
        case "hash":
        case "zset":
        case "none":
            return value;
        default:
            return "error";
    }
}

function unique(values: Iterable<string>): string[] {
    return [...new Set([...values].filter((value) => value.trim() !== ""))].sort((a, b) =>
        a.localeCompare(b),
    );
}

async function getAuthorizedUsername(): Promise<string | null> {
    const username = await reddit.getCurrentUsername();
    if (!username || !DEBUG_USERS.has(username)) {
        return null;
    }
    return username;
}

async function getExistingKeys(keys: string[], source: string): Promise<KeyCatalogItemDto[]> {
    const uniqueKeys = unique(keys);
    const typed = await Promise.all(
        uniqueKeys.map(async (key) => ({
            key,
            type: toRedisType(await redis.type(key)),
            source,
        })),
    );

    return typed.filter(
        (item): item is KeyCatalogItemDto => item.type === "string" || item.type === "hash" || item.type === "zset" || item.type === "none",
    ).filter((item) => item.type !== "none");
}

async function buildKeyCatalog(): Promise<KeyCatalogResponseDto> {
    const [levelPostIdsRaw, dailyPostIdsRaw] = await Promise.all([
        redis.zRange("levelList", 0, -1),
        redis.zRange("dailyList", 0, -1),
    ]);

    const levelPostIds = zRangeMembers(levelPostIdsRaw);
    const dailyPostIds = zRangeMembers(dailyPostIdsRaw);

    const postIds = unique([...levelPostIds, ...dailyPostIds]);
    const postLevelPairs = await Promise.all(
        postIds.map(async (postId) => ({
            postId,
            levelId: await redis.get(`post:${postId}:levelID`),
        })),
    );

    const levelIds = unique(
        postLevelPairs
            .map((entry) => entry.levelId ?? "")
            .filter((levelId) => levelId !== ""),
    );

    const leaderboardMembers = await Promise.all(
        postIds.map(async (postId) => ({
            postId,
            members: zRangeMembers(await redis.zRange(`lb:${postId}`, 0, -1)),
        })),
    );

    const puzzleEntries = await Promise.all(
        levelIds.map(async (levelId) => ({
            levelId,
            data: await redis.hGetAll(`puzzle:${levelId}`),
        })),
    );

    const usernames = unique([
        ...leaderboardMembers.flatMap((entry) => entry.members),
        ...puzzleEntries
            .map((entry) => entry.data.levelCreator ?? "")
            .filter((creator) => creator !== ""),
    ]);

    const stateKeys = leaderboardMembers.flatMap((entry) =>
        entry.members.map((username) => `state:${entry.postId}:${username}`),
    );

    const userKeys = usernames.flatMap((username) => [
        `profile:${username}`,
        `user:${username}:puzzleCount`,
        `user:${username}:puzzles`,
    ]);

    const sections = [
        {
            title: "System",
            keys: await getExistingKeys(FIXED_SYSTEM_KEYS, "system"),
        },
        {
            title: "Posts",
            keys: await getExistingKeys(
                postIds.flatMap((postId) => [`lb:${postId}`, `post:${postId}:levelID`]),
                "post-index",
            ),
        },
        {
            title: "Puzzles",
            keys: await getExistingKeys(levelIds.map((levelId) => `puzzle:${levelId}`), "puzzle-data"),
        },
        {
            title: "Users",
            keys: await getExistingKeys(userKeys, "user-data"),
        },
        {
            title: "State Snapshots",
            keys: await getExistingKeys(stateKeys, "player-state"),
        },
    ].filter((section) => section.keys.length > 0);

    return {
        sections,
        totalKeys: sections.reduce((sum, section) => sum + section.keys.length, 0),
        note:
            "Catalog is derived from application-owned indices because the Devvit Redis SDK does not expose a keyspace SCAN/KEYS API.",
    };
}

async function inspectKey(keyInfo: KeyDebugRequestDto): Promise<KeyDebugResponseDto> {
    if (!keyInfo.key) {
        return {
            type: "error",
            error: "A key must be specified.",
        };
    }

    const key = keyInfo.key.trim();
    if (!key) {
        return {
            type: "error",
            error: "A key must be specified.",
        };
    }

    const type = toRedisType(await redis.type(key));
    const response: KeyDebugResponseDto = {
        key,
        type,
    };

    switch (type) {
        case "string":
            response.data = (await redis.get(key)) ?? "";
            return response;
        case "hash":
            response.data = await redis.hGetAll(key);
            return response;
        case "zset": {
            const cursor = Number.isFinite(keyInfo.cursor) ? Number(keyInfo.cursor) : 0;
            const count = Number.isFinite(keyInfo.count) ? Number(keyInfo.count) : DEFAULT_ZSET_COUNT;
            const zResult = await redis.zScan(key, cursor, undefined, count);
            response.cursor = zResult.cursor;
            response.data = zResult.members;
            return response;
        }
        case "none":
            response.error = "Key not found.";
            return response;
        default:
            return {
                key,
                type: "error",
                error: `Unsupported Redis type returned for key: ${type}`,
            };
    }
}

async function mutateKey(keyInfo: KeyDebugRequestDto): Promise<KeyDebugResponseDto> {
    if (!keyInfo.key) {
        return {
            type: "error",
            error: "A key must be specified.",
        };
    }

    const key = keyInfo.key.trim();
    if (!key) {
        return {
            type: "error",
            error: "A key must be specified.",
        };
    }

    const action = keyInfo.action;
    const type = toRedisType(await redis.type(key));

    if (action === "set-string") {
        if (type === "hash" || type === "zset") {
            return { type: "error", key, error: `Cannot set string on ${type} key.` };
        }

        await redis.set(key, String(keyInfo.value ?? ""));
        return inspectKey({ key, action: "get" });
    }

    if (action === "delete-key") {
        await redis.del(key);
        return inspectKey({ key, action: "get" });
    }

    if (action === "set-hash-field") {
        if (type === "string" || type === "zset") {
            return { type: "error", key, error: `Cannot set hash field on ${type} key.` };
        }

        const field = String(keyInfo.field ?? "").trim();
        if (!field) {
            return { type: "error", key, error: "Hash field is required." };
        }

        await redis.hSet(key, { [field]: String(keyInfo.value ?? "") });
        return inspectKey({ key, action: "get" });
    }

    if (action === "delete-hash-field") {
        if (type !== "hash") {
            return { type: "error", key, error: "Key is not a hash." };
        }

        const field = String(keyInfo.field ?? "").trim();
        if (!field) {
            return { type: "error", key, error: "Hash field is required." };
        }

        const hash = await redis.hGetAll(key);
        if (!(field in hash)) {
            return inspectKey({ key, action: "get" });
        }

        delete hash[field];
        await redis.del(key);

        const fields = Object.entries(hash);
        if (fields.length > 0) {
            const nextHash = Object.fromEntries(fields);
            await redis.hSet(key, nextHash);
        }

        return inspectKey({ key, action: "get" });
    }

    if (action === "add-zset-member") {
        if (type === "string" || type === "hash") {
            return { type: "error", key, error: `Cannot add zset member on ${type} key.` };
        }

        const member = String(keyInfo.member ?? "").trim();
        if (!member) {
            return { type: "error", key, error: "ZSET member is required." };
        }

        const score = Number(keyInfo.score);
        if (!Number.isFinite(score)) {
            return { type: "error", key, error: "ZSET score must be a valid number." };
        }

        await redis.zAdd(key, { member, score });
        return inspectKey({ key, action: "get" });
    }

    if (action === "remove-zset-member") {
        if (type !== "zset") {
            return { type: "error", key, error: "Key is not a zset." };
        }

        const member = String(keyInfo.member ?? "").trim();
        if (!member) {
            return { type: "error", key, error: "ZSET member is required." };
        }

        await redis.zRem(key, [member]);
        return inspectKey({ key, action: "get" });
    }

    return {
        type: "error",
        key,
        error: "Unsupported action.",
    };
}

export const registerDebugRoutes = (router: Hono) => {
    router.get("/api/debug/catalog", async (c) => {
        const logger = await Logger.Create("Debug API - Catalog");
        logger.traceStart("Catalog Start");

        try {
            const username = await getAuthorizedUsername();
            if (!username) {
                return c.json(
                    {
                        sections: [],
                        totalKeys: 0,
                        error: "Forbidden",
                    },
                    403,
                );
            }

            logger.info(`Catalog requested by ${username}`);
            return c.json(await buildKeyCatalog());
        } catch (error) {
            logger.error("Error building debug catalog:", error);
            return c.json(
                {
                    sections: [],
                    totalKeys: 0,
                    error: "An unknown error occurred while building the key catalog.",
                },
                500,
            );
        } finally {
            logger.traceEnd();
        }
    });

    router.post("/api/debug/key", async (c) => {
        const logger = await Logger.Create("Debug API - Action on Key");
        logger.traceStart("Api Start");

        try {
            const username = await getAuthorizedUsername();
            if (!username) {
                return c.json(
                    {
                        type: "error",
                        error: "Forbidden",
                    },
                    403,
                );
            }

            const keyInfo = (await c.req.json()) as KeyDebugRequestDto;
            if (!keyInfo || !keyInfo.key || !keyInfo.action) {
                return c.json(
                    {
                        type: "error",
                        error: "A key or action type was not specified.",
                    },
                    400,
                );
            }

            logger.info(`Debug action by ${username}: ${keyInfo.action} ${keyInfo.key}`);

            if (keyInfo.action === "get") {
                return c.json(await inspectKey(keyInfo));
            }

            return c.json(await mutateKey(keyInfo));
        } catch (error) {
            logger.error("Error executing debug API:", error);
            return c.json(
                {
                    type: "error",
                    error: "An unknown error occurred.",
                },
                500,
            );
        } finally {
            logger.traceEnd();
        }
    });
};
