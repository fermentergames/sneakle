/*!
 * Registers all paths for the debug view.
 *
 * Author: u/Beach-Brews
 * License: BSD-3-Clause
 */

import { Router } from 'express';
import { Logger } from './utils/Logger';  
import { redis } from '@devvit/web/server';
import { KeyDebugRequestDto, KeyDebugResponseDto } from '../shared/debugTypes';

export const registerDebugRoutes = (router: Router) => {

    router.post<void, KeyDebugResponseDto, string>(
        "/api/debug/key",
        async (req, res) => {
            const logger = await Logger.Create('Debug API - Action on Key');
            logger.traceStart('Api Start');

            try {

                const keyInfo = JSON.parse(req.body) as KeyDebugRequestDto;
                if (!keyInfo || !keyInfo.key || !keyInfo.action) {
                    res.status(400).json({
                        type: 'error',
                        error: 'A key was or action type was not specified'
                    });
                    return;
                }

                // Get key type
                const response = {
                    key: keyInfo.key,
                    type: await redis.type(keyInfo.key)
                } as KeyDebugResponseDto;

                // Fetch based on key type
                switch (response.type) {
                    case 'string':
                        response.data = await redis.get(keyInfo.key);
                        break;

                    case 'hash':
                        response.data = await redis.hGetAll(keyInfo.key);
                        break;

                    case 'zset': {
                        const cursor: number = (!keyInfo.cursor || isNaN(keyInfo.cursor))
                            ? 0
                            : keyInfo.cursor
                        ?? 0;
                        const zResult = await redis.zScan(keyInfo.key, cursor);
                        response.cursor = zResult.cursor;
                        response.data = zResult.members;
                        break;
                    }
                }

                res.status(200).json(response);

            } catch(e) {
                logger.error('Error executing API: ', e);
                res.status(500).json({
                    type: 'error',
                    error: 'An unknown error ocurred.'
                });
            } finally {
                logger.traceEnd();
            }
        }
    );

};
