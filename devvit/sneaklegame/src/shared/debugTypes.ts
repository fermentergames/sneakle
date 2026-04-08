/*!
* Types used by the front-end debug page and back-end debug APIs.
*
* Author:  u/Beach-Brews
* License: BSD-3-Clause
*/

export type KeyTypes = 'get' | undefined;

export type KeyForm = {
  key: string;
  action: KeyTypes
}

export type KeyDebugRequestDto = {
  key?: string | undefined;
  action?: 'get' | undefined;
  cursor?: number | undefined;
};

export type KeyDebugHashValueDto = { [prop: string]: string };
export type KeyDebugZMemberDto = {score: number, member: string};

export type KeyDebugResponseDto = {
  type: 'string' | 'hash' | 'zset' | 'error';
  key?: string | undefined;
  data?: string | KeyDebugHashValueDto | KeyDebugZMemberDto[] | undefined;
  cursor?: number | undefined;
  error?: string | undefined;
};
