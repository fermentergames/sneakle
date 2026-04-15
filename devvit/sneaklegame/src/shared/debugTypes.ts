/*!
* Types used by the front-end debug page and back-end debug APIs.
*
* Author:  u/Beach-Brews
* License: BSD-3-Clause
*/

export type KeyTypes =
  | "get"
  | "set-string"
  | "delete-key"
  | "set-hash-field"
  | "delete-hash-field"
  | "add-zset-member"
  | "remove-zset-member"
  | undefined;

export type DebugRedisType = "string" | "hash" | "zset" | "none" | "error";

export type KeyForm = {
  key: string;
  action: KeyTypes;
};

export type KeyDebugRequestDto = {
  key?: string | undefined;
  action?: KeyTypes;
  cursor?: number | undefined;
  count?: number | undefined;
  value?: string | undefined;
  field?: string | undefined;
  member?: string | undefined;
  score?: number | undefined;
};

export type KeyDebugHashValueDto = { [prop: string]: string };
export type KeyDebugZMemberDto = { score: number; member: string };

export type KeyCatalogItemDto = {
  key: string;
  type: Exclude<DebugRedisType, "error">;
  source: string;
};

export type KeyCatalogSectionDto = {
  title: string;
  keys: KeyCatalogItemDto[];
};

export type KeyCatalogResponseDto = {
  sections: KeyCatalogSectionDto[];
  totalKeys: number;
  note?: string | undefined;
  error?: string | undefined;
};

export type KeyDebugResponseDto = {
  type: DebugRedisType;
  key?: string | undefined;
  data?: string | KeyDebugHashValueDto | KeyDebugZMemberDto[] | undefined;
  cursor?: number | undefined;
  error?: string | undefined;
};
