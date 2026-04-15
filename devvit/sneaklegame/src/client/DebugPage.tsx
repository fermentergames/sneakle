import {
    KeyCatalogItemDto,
    KeyCatalogResponseDto,
    KeyDebugHashValueDto,
    KeyDebugRequestDto,
    KeyDebugResponseDto,
    KeyDebugZMemberDto,
} from "../shared/debugTypes";

type ThemeMode = "light" | "dark";
type DebugDialogField = {
    name: string;
    label: string;
    value?: string;
    inputType?: "text" | "number" | "textarea";
    placeholder?: string;
};
const THEME_STORAGE_KEY = "sneakle_debug_theme";
const DEBUG_CLOSE_PATH = "/splash.html";

function escapeHtml(value: string): string {
    return value
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}

function formatStringValue(value: string): string {
    try {
        return JSON.stringify(JSON.parse(value), null, 2);
    } catch {
        return value;
    }
}

function renderResultBody(result: KeyDebugResponseDto | null, selectedZsetMembers: Set<string>): string {
    if (!result) {
        return '<div class="debug-empty">Select or enter a key to inspect it.</div>';
    }

    if (result.type === "error") {
        return `<div class="debug-error">${escapeHtml(result.error ?? "Unknown error")}</div>`;
    }

    if (result.type === "none") {
        return '<div class="debug-empty">Key not found.</div>';
    }

    if (result.type === "string") {
        return `<pre class="debug-pre">${escapeHtml(formatStringValue(String(result.data ?? "")))}</pre>`;
    }

    if (result.type === "hash") {
        const entries = Object.entries((result.data ?? {}) as KeyDebugHashValueDto);
        if (entries.length === 0) {
            return '<div class="debug-empty">Hash has no fields.</div>';
        }
        return `
            <table class="debug-table">
                <thead><tr><th>Field</th><th>Value</th><th></th></tr></thead>
                <tbody>
                    ${entries
                        .map(
                            ([field, value]) =>
                                `<tr><td>${escapeHtml(field)}</td><td><pre>${escapeHtml(formatStringValue(value))}</pre></td><td class="debug-table-action-cell"><div class="debug-row-actions"><button class="debug-row-edit" data-action="edit-hash-field" data-field="${escapeHtml(field)}" data-value="${escapeHtml(value)}" type="button">Edit</button><button class="debug-row-delete" data-action="delete-hash-field" data-field="${escapeHtml(field)}" type="button">Delete</button></div></td></tr>`,
                        )
                        .join("")}
                </tbody>
            </table>
        `;
    }

    const members = (result.data ?? []) as KeyDebugZMemberDto[];
    if (members.length === 0) {
        return '<div class="debug-empty">Sorted set page is empty.</div>';
    }

    const allSelected = members.every((member) => selectedZsetMembers.has(member.member));
    const selectedCount = members.filter((member) => selectedZsetMembers.has(member.member)).length;

    return `
        <div class="debug-result-bulkbar">
            <label class="debug-checkbox-wrap">
                <input class="debug-zset-select-all" type="checkbox" ${allSelected ? "checked" : ""} />
                <span>Select page</span>
            </label>
            <div class="debug-result-bulkbar-actions">
                <span class="debug-result-bulkbar-meta">${selectedCount} selected</span>
                <button class="debug-button debug-button-secondary debug-bulk-delete" type="button" ${selectedCount <= 0 ? "disabled" : ""}>Delete Selected</button>
            </div>
        </div>
        <table class="debug-table">
            <thead><tr><th></th><th>Member</th><th>Score</th><th></th></tr></thead>
            <tbody>
                ${members
                    .map(
                        (member) =>
                            `<tr><td class="debug-table-check-cell"><input class="debug-zset-select" data-member="${escapeHtml(member.member)}" type="checkbox" ${selectedZsetMembers.has(member.member) ? "checked" : ""} /></td><td>${escapeHtml(member.member)}</td><td>${escapeHtml(String(member.score))}</td><td class="debug-table-action-cell"><div class="debug-row-actions"><button class="debug-row-edit" data-action="edit-zset-member" data-member="${escapeHtml(member.member)}" data-score="${escapeHtml(String(member.score))}" type="button">Edit</button><button class="debug-row-delete" data-action="remove-zset-member" data-member="${escapeHtml(member.member)}" type="button">Delete</button></div></td></tr>`,
                    )
                    .join("")}
            </tbody>
        </table>
    `;
}

function renderCatalogSection(section: { title: string; keys: KeyCatalogItemDto[] }): string {
    return `
        <details class="debug-section">
            <summary class="debug-section-header debug-section-summary">
                <h2>${escapeHtml(section.title)}</h2>
                <span>${section.keys.length}</span>
            </summary>
            <div class="debug-key-list">
                ${section.keys
                    .map(
                        (item) => `
                            <button class="debug-key-button" data-key="${escapeHtml(item.key)}" type="button">
                                <span class="debug-key-name">${escapeHtml(item.key)}</span>
                                <span class="debug-key-meta">${escapeHtml(item.type)} • ${escapeHtml(item.source)}</span>
                            </button>
                        `,
                    )
                    .join("")}
            </div>
        </details>
    `;
}

export function mountDebugPage(root: HTMLElement): void {
    root.innerHTML = `
        <div class="debug-shell">
            <aside class="debug-sidebar">
                <div class="debug-sidebar-top">
                    <div class="debug-header-row">
                        <h1>Redis Debug Console</h1>
                        <div class="debug-header-actions">
                            <button id="theme-toggle" class="debug-icon-button debug-theme-toggle" type="button" title="Switch theme" aria-label="Switch theme">🌙</button>
                            <button id="close-debug" class="debug-icon-button debug-close-button" type="button" title="Close debug view" aria-label="Close debug view">✕</button>
                        </div>
                    </div>
                    <p class="debug-kicker">Sneakle Tools</p>
                    <p class="debug-note" id="debug-note">Loading key catalog...</p>
                    <div class="debug-toolbar">
                        <input id="catalog-filter" class="debug-input" type="search" placeholder="Filter keys" />
                        <button id="refresh-catalog" class="debug-button debug-button-secondary" type="button">Refresh</button>
                    </div>
                </div>
                <div id="catalog-output" class="debug-catalog"></div>
            </aside>
            <main class="debug-main">
                <div class="debug-panel">
                    <div class="debug-panel-header">
                        <div>
                            <p class="debug-kicker">Inspector</p>
                            <h2>Exact Key Lookup</h2>
                        </div>
                        <div id="inspect-status" class="debug-status">Idle</div>
                    </div>
                    <div class="debug-toolbar">
                        <input id="key-input" class="debug-input debug-input-mono" type="text" placeholder="profile:FermenterGames" />
                        <button id="inspect-key" class="debug-button" type="button">Inspect</button>
                    </div>
                    <div class="debug-actions">
                        <div class="debug-action-head">Edit/Create/Delete</div>
                        <div class="debug-action-grid">
                            <section id="string-actions" class="debug-action-section">
                                <h3>String</h3>
                                <textarea id="string-value" class="debug-input debug-input-mono debug-textarea" placeholder="String value"></textarea>
                                <div class="debug-action-row">
                                    <button id="set-string" class="debug-button debug-action-btn" type="button">Save String</button>
                                    <button id="delete-key" class="debug-button debug-button-secondary debug-action-btn" type="button">Delete Key</button>
                                </div>
                            </section>
                            <section id="hash-actions" class="debug-action-section">
                                <h3>Hash</h3>
                                <input id="hash-field" class="debug-input debug-input-mono" type="text" placeholder="Field" />
                                <textarea id="hash-value" class="debug-input debug-input-mono debug-textarea" placeholder="Value"></textarea>
                                <div class="debug-action-row">
                                    <button id="set-hash-field" class="debug-button debug-action-btn" type="button">Set Field</button>
                                </div>
                            </section>
                            <section id="zset-actions" class="debug-action-section">
                                <h3>ZSET</h3>
                                <input id="zset-member" class="debug-input debug-input-mono" type="text" placeholder="Member" />
                                <input id="zset-score" class="debug-input debug-input-mono" type="number" step="any" placeholder="Score" />
                                <div class="debug-action-row">
                                    <button id="add-zset-member" class="debug-button debug-action-btn" type="button">Add/Update Member</button>
                                </div>
                                <input id="zset-remove-member" class="debug-input debug-input-mono" type="text" placeholder="Member to remove" />
                                <div class="debug-action-row">
                                    <button id="remove-zset-member" class="debug-button debug-button-secondary debug-action-btn" type="button">Remove Member</button>
                                </div>
                            </section>
                        </div>
                    </div>
                    <div id="result-meta" class="debug-result-meta"></div>
                    <div id="result-output" class="debug-result"></div>
                    <div class="debug-pagination">
                        <button id="load-more" class="debug-button debug-button-secondary" type="button" hidden>Load More ZSET Entries</button>
                    </div>
                </div>
            </main>
        </div>
        <div id="debug-dialog" class="debug-dialog hidden" aria-hidden="true">
            <div class="debug-dialog-backdrop"></div>
            <div class="debug-dialog-card" role="dialog" aria-modal="true" aria-labelledby="debug-dialog-title">
                <div class="debug-dialog-header">
                    <h3 id="debug-dialog-title">Confirm</h3>
                </div>
                <p id="debug-dialog-message" class="debug-dialog-message"></p>
                <div id="debug-dialog-fields" class="debug-dialog-fields"></div>
                <div class="debug-dialog-actions">
                    <button id="debug-dialog-cancel" class="debug-button debug-button-secondary" type="button">Cancel</button>
                    <button id="debug-dialog-confirm" class="debug-button" type="button">Confirm</button>
                </div>
            </div>
        </div>
    `;

    const noteEl = root.querySelector("#debug-note") as HTMLParagraphElement;
    const catalogOutputEl = root.querySelector("#catalog-output") as HTMLDivElement;
    const filterEl = root.querySelector("#catalog-filter") as HTMLInputElement;
    const closeDebugEl = root.querySelector("#close-debug") as HTMLButtonElement;
    const themeToggleEl = root.querySelector("#theme-toggle") as HTMLButtonElement;
    const refreshButtonEl = root.querySelector("#refresh-catalog") as HTMLButtonElement;
    const keyInputEl = root.querySelector("#key-input") as HTMLInputElement;
    const inspectButtonEl = root.querySelector("#inspect-key") as HTMLButtonElement;
    const inspectStatusEl = root.querySelector("#inspect-status") as HTMLDivElement;
    const resultMetaEl = root.querySelector("#result-meta") as HTMLDivElement;
    const resultOutputEl = root.querySelector("#result-output") as HTMLDivElement;
    const loadMoreEl = root.querySelector("#load-more") as HTMLButtonElement;
    const debugPanelEl = root.querySelector(".debug-panel") as HTMLDivElement;
    const dialogEl = root.querySelector("#debug-dialog") as HTMLDivElement;
    const dialogBackdropEl = root.querySelector(".debug-dialog-backdrop") as HTMLDivElement;
    const dialogTitleEl = root.querySelector("#debug-dialog-title") as HTMLHeadingElement;
    const dialogMessageEl = root.querySelector("#debug-dialog-message") as HTMLParagraphElement;
    const dialogFieldsEl = root.querySelector("#debug-dialog-fields") as HTMLDivElement;
    const dialogCancelEl = root.querySelector("#debug-dialog-cancel") as HTMLButtonElement;
    const dialogConfirmEl = root.querySelector("#debug-dialog-confirm") as HTMLButtonElement;
    const stringActionsEl = root.querySelector("#string-actions") as HTMLElement;
    const hashActionsEl = root.querySelector("#hash-actions") as HTMLElement;
    const zsetActionsEl = root.querySelector("#zset-actions") as HTMLElement;
    const stringValueEl = root.querySelector("#string-value") as HTMLTextAreaElement;
    const deleteKeyEl = root.querySelector("#delete-key") as HTMLButtonElement;
    const setStringEl = root.querySelector("#set-string") as HTMLButtonElement;
    const hashFieldEl = root.querySelector("#hash-field") as HTMLInputElement;
    const hashValueEl = root.querySelector("#hash-value") as HTMLTextAreaElement;
    const setHashFieldEl = root.querySelector("#set-hash-field") as HTMLButtonElement;
    const zsetMemberEl = root.querySelector("#zset-member") as HTMLInputElement;
    const zsetScoreEl = root.querySelector("#zset-score") as HTMLInputElement;
    const zsetRemoveMemberEl = root.querySelector("#zset-remove-member") as HTMLInputElement;
    const addZsetMemberEl = root.querySelector("#add-zset-member") as HTMLButtonElement;
    const removeZsetMemberEl = root.querySelector("#remove-zset-member") as HTMLButtonElement;
    const actionButtons = root.querySelectorAll(".debug-action-btn") as NodeListOf<HTMLButtonElement>;

    let catalog: KeyCatalogResponseDto | null = null;
    let currentResult: KeyDebugResponseDto | null = null;
    let activeDialogResolve: ((value: boolean | Record<string, string> | null) => void) | null = null;
    let selectedZsetMembers = new Set<string>();

    const applyTheme = (theme: ThemeMode) => {
        root.dataset.theme = theme;
        const nextLabel = theme === "dark" ? "Switch to light mode" : "Switch to dark mode";
        themeToggleEl.textContent = theme === "dark" ? "☀️" : "🌙";
        themeToggleEl.title = nextLabel;
        themeToggleEl.setAttribute("aria-label", nextLabel);
    };

    const getSavedTheme = (): ThemeMode => {
        try {
            const saved = localStorage.getItem(THEME_STORAGE_KEY);
            if (saved === "light" || saved === "dark") {
                return saved;
            }
        } catch {
            // Ignore storage issues and fall back to default theme.
        }
        return "dark";
    };

    const toggleTheme = () => {
        const nextTheme: ThemeMode = root.dataset.theme === "dark" ? "light" : "dark";
        applyTheme(nextTheme);
        try {
            localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
        } catch {
            // Ignore storage issues; theme still updates for this session.
        }
    };

    const closeDebugView = () => {
        try {
            const sameOriginReferrer =
                !!document.referrer &&
                new URL(document.referrer).origin === window.location.origin;

            if (sameOriginReferrer && window.history.length > 1) {
                window.history.back();
                return;
            }
        } catch {
            // Fall through to explicit path.
        }

        window.location.href = DEBUG_CLOSE_PATH;
    };

    const scrollToResultArea = () => {
        debugPanelEl.scrollIntoView({ behavior: "auto", block: "start" });
    };

    const closeDialog = (value: boolean | Record<string, string> | null) => {
        dialogEl.classList.add("hidden");
        dialogEl.setAttribute("aria-hidden", "true");
        dialogFieldsEl.innerHTML = "";
        const resolver = activeDialogResolve;
        activeDialogResolve = null;
        resolver?.(value);
    };

    const openConfirmDialog = (message: string, title = "Confirm", confirmLabel = "Confirm") => {
        return new Promise<boolean>((resolve) => {
            dialogTitleEl.textContent = title;
            dialogMessageEl.textContent = message;
            dialogFieldsEl.innerHTML = "";
            dialogCancelEl.textContent = "Cancel";
            dialogConfirmEl.textContent = confirmLabel;
            dialogConfirmEl.classList.remove("debug-button-danger");
            dialogConfirmEl.classList.add("debug-button-danger");
            dialogEl.classList.remove("hidden");
            dialogEl.setAttribute("aria-hidden", "false");
            activeDialogResolve = (value) => {
                resolve(value === true);
            };
            dialogConfirmEl.focus();
        });
    };

    const openFieldDialog = (
        title: string,
        message: string,
        fields: DebugDialogField[],
        confirmLabel = "Save",
    ) => {
        return new Promise<Record<string, string> | null>((resolve) => {
            dialogTitleEl.textContent = title;
            dialogMessageEl.textContent = message;
            dialogFieldsEl.innerHTML = fields
                .map((field) => {
                    const inputId = `debug-dialog-field-${field.name}`;
                    if (field.inputType === "textarea") {
                        return `
                            <label class="debug-dialog-field" for="${inputId}">
                                <span>${escapeHtml(field.label)}</span>
                                <textarea id="${inputId}" class="debug-input debug-input-mono debug-dialog-textarea" data-field-name="${escapeHtml(field.name)}" placeholder="${escapeHtml(field.placeholder ?? "")}">${escapeHtml(field.value ?? "")}</textarea>
                            </label>
                        `;
                    }

                    return `
                        <label class="debug-dialog-field" for="${inputId}">
                            <span>${escapeHtml(field.label)}</span>
                            <input id="${inputId}" class="debug-input debug-input-mono" data-field-name="${escapeHtml(field.name)}" type="${escapeHtml(field.inputType ?? "text")}" value="${escapeHtml(field.value ?? "")}" placeholder="${escapeHtml(field.placeholder ?? "")}" />
                        </label>
                    `;
                })
                .join("");
            dialogCancelEl.textContent = "Cancel";
            dialogConfirmEl.textContent = confirmLabel;
            dialogConfirmEl.classList.remove("debug-button-danger");
            dialogEl.classList.remove("hidden");
            dialogEl.setAttribute("aria-hidden", "false");
            activeDialogResolve = (value) => {
                resolve((value && typeof value === "object") ? value : null);
            };

            const firstField = dialogFieldsEl.querySelector("input, textarea") as HTMLInputElement | HTMLTextAreaElement | null;
            firstField?.focus();
        });
    };

    const updateResult = (result: KeyDebugResponseDto | null) => {
        currentResult = result;
        resultMetaEl.textContent = result?.key ? `${result.type} • ${result.key}` : "";
        if (result?.type === "zset") {
            const visibleMembers = new Set(((result.data ?? []) as KeyDebugZMemberDto[]).map((member) => member.member));
            selectedZsetMembers = new Set([...selectedZsetMembers].filter((member) => visibleMembers.has(member)));
        } else {
            selectedZsetMembers.clear();
        }

        resultOutputEl.innerHTML = renderResultBody(result, selectedZsetMembers);
        loadMoreEl.hidden = !(result?.type === "zset" && typeof result.cursor === "number" && result.cursor !== 0 && result.key);

        const hasEditableKey = keyInputEl.value.trim().length > 0;
        const editableType = result?.type ?? "none";
        const showStringActions = editableType === "string" || editableType === "none" || editableType === "error";
        const showHashActions = editableType === "hash" || editableType === "none" || editableType === "error";
        const showZsetActions = editableType === "zset" || editableType === "none" || editableType === "error";

        stringActionsEl.hidden = !showStringActions;
        hashActionsEl.hidden = !showHashActions;
        zsetActionsEl.hidden = !showZsetActions;

        if (result?.type === "string") {
            stringValueEl.value = String(result.data ?? "");
        }

        const keyExists = editableType !== "none" && editableType !== "error";
        deleteKeyEl.disabled = !hasEditableKey || !keyExists;
    };

    const mutateKey = async (
        payload: Omit<KeyDebugRequestDto, "key">,
        options?: { confirmMessage?: string; successLabel?: string },
    ) => {
        const key = keyInputEl.value.trim();
        if (!key) {
            inspectStatusEl.textContent = "Enter a key";
            updateResult({ type: "error", error: "Enter a key first." });
            return;
        }

        if (options?.confirmMessage) {
            const confirmed = await openConfirmDialog(options.confirmMessage, "Confirm Action", "Confirm");
            if (!confirmed) {
                return;
            }
        }

        inspectStatusEl.textContent = "Saving...";
        inspectButtonEl.disabled = true;
        loadMoreEl.disabled = true;
        actionButtons.forEach((btn) => {
            btn.disabled = true;
        });

        try {
            const response = await fetch("/api/debug/key", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    key,
                    ...payload,
                }),
            });
            const data = (await response.json()) as KeyDebugResponseDto;
            updateResult(data);
            inspectStatusEl.textContent = response.ok ? (options?.successLabel ?? "Saved") : "Error";
            await loadCatalog();
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            inspectStatusEl.textContent = "Error";
            updateResult({ type: "error", key, error: message });
        } finally {
            inspectButtonEl.disabled = false;
            loadMoreEl.disabled = false;
            actionButtons.forEach((btn) => {
                btn.disabled = false;
            });
        }
    };

    const renderCatalog = () => {
        if (!catalog) {
            catalogOutputEl.innerHTML = "";
            return;
        }

        const filterValue = filterEl.value.trim().toLowerCase();
        const sections = catalog.sections
            .map((section) => ({
                ...section,
                keys: section.keys.filter((item) =>
                    !filterValue || item.key.toLowerCase().includes(filterValue) || item.source.toLowerCase().includes(filterValue),
                ),
            }))
            .filter((section) => section.keys.length > 0);

        if (sections.length === 0) {
            catalogOutputEl.innerHTML = '<div class="debug-empty">No keys matched this filter.</div>';
            return;
        }

        catalogOutputEl.innerHTML = sections.map(renderCatalogSection).join("");
        catalogOutputEl.querySelectorAll<HTMLButtonElement>(".debug-key-button").forEach((button) => {
            button.addEventListener("click", () => {
                keyInputEl.value = button.dataset.key ?? "";
                void inspectKey(0, true);
            });
        });
    };

    const loadCatalog = async () => {
        noteEl.textContent = "Loading key catalog...";
        refreshButtonEl.disabled = true;

        try {
            const response = await fetch("/api/debug/catalog");
            const data = (await response.json()) as KeyCatalogResponseDto;
            catalog = data;

            if (!response.ok || data.error) {
                noteEl.textContent = data.error ?? "Failed to load key catalog.";
                catalogOutputEl.innerHTML = '<div class="debug-error">Catalog request failed.</div>';
                return;
            }

            noteEl.textContent = `${data.totalKeys} keys available. ${data.note ?? ""}`.trim();
            renderCatalog();
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            noteEl.textContent = `Failed to load key catalog: ${message}`;
            catalogOutputEl.innerHTML = '<div class="debug-error">Catalog request failed.</div>';
        } finally {
            refreshButtonEl.disabled = false;
        }
    };

    const inspectKey = async (cursor = 0, scrollToResult = false) => {
        const key = keyInputEl.value.trim();
        if (!key) {
            inspectStatusEl.textContent = "Enter a key";
            updateResult({ type: "error", error: "Enter a key to inspect." });
            if (scrollToResult) {
                scrollToResultArea();
            }
            return;
        }

        inspectStatusEl.textContent = cursor > 0 ? "Loading next page..." : "Inspecting...";
        inspectButtonEl.disabled = true;
        loadMoreEl.disabled = true;

        try {
            const payload: KeyDebugRequestDto = { key, action: "get", cursor };
            const response = await fetch("/api/debug/key", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
            });
            const data = (await response.json()) as KeyDebugResponseDto;

            if (cursor > 0 && currentResult?.type === "zset" && data.type === "zset") {
                updateResult({
                    ...data,
                    data: [
                        ...((currentResult.data ?? []) as KeyDebugZMemberDto[]),
                        ...((data.data ?? []) as KeyDebugZMemberDto[]),
                    ],
                });
            } else {
                updateResult(data);
            }

            inspectStatusEl.textContent = response.ok ? "Loaded" : "Error";
            if (scrollToResult) {
                scrollToResultArea();
            }
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            inspectStatusEl.textContent = "Error";
            updateResult({ type: "error", key, error: message });
            if (scrollToResult) {
                scrollToResultArea();
            }
        } finally {
            inspectButtonEl.disabled = false;
            loadMoreEl.disabled = false;
        }
    };

    filterEl.addEventListener("input", renderCatalog);
    closeDebugEl.addEventListener("click", closeDebugView);
    themeToggleEl.addEventListener("click", toggleTheme);
    refreshButtonEl.addEventListener("click", () => {
        void loadCatalog();
    });
    inspectButtonEl.addEventListener("click", () => {
        void inspectKey();
    });
    keyInputEl.addEventListener("keydown", (event) => {
        if (event.key === "Enter") {
            event.preventDefault();
            void inspectKey();
        }
    });
    loadMoreEl.addEventListener("click", () => {
        if (currentResult?.type === "zset" && typeof currentResult.cursor === "number") {
            void inspectKey(currentResult.cursor);
        }
    });

    dialogBackdropEl.addEventListener("click", () => {
        closeDialog(null);
    });

    dialogCancelEl.addEventListener("click", () => {
        closeDialog(null);
    });

    dialogConfirmEl.addEventListener("click", () => {
        const fields = dialogFieldsEl.querySelectorAll<HTMLInputElement | HTMLTextAreaElement>("[data-field-name]");
        if (fields.length === 0) {
            closeDialog(true);
            return;
        }

        const values: Record<string, string> = {};
        fields.forEach((field) => {
            values[field.dataset.fieldName ?? ""] = field.value;
        });
        closeDialog(values);
    });

    root.addEventListener("keydown", (event) => {
        if (event.key === "Escape" && !dialogEl.classList.contains("hidden")) {
            event.preventDefault();
            closeDialog(null);
        }

        if (event.key === "Enter" && !dialogEl.classList.contains("hidden")) {
            const target = event.target;
            if (target instanceof HTMLTextAreaElement) {
                return;
            }
            event.preventDefault();
            dialogConfirmEl.click();
        }
    });

    resultOutputEl.addEventListener("click", (event) => {
        const target = event.target;
        if (!(target instanceof HTMLElement)) {
            return;
        }

        if (target instanceof HTMLInputElement && target.classList.contains("debug-zset-select")) {
            const member = target.dataset.member?.trim();
            if (!member) {
                return;
            }

            if (target.checked) {
                selectedZsetMembers.add(member);
            } else {
                selectedZsetMembers.delete(member);
            }
            updateResult(currentResult);
            return;
        }

        if (target instanceof HTMLInputElement && target.classList.contains("debug-zset-select-all")) {
            if (currentResult?.type !== "zset") {
                return;
            }

            const members = ((currentResult.data ?? []) as KeyDebugZMemberDto[]).map((member) => member.member);
            if (target.checked) {
                members.forEach((member) => selectedZsetMembers.add(member));
            } else {
                members.forEach((member) => selectedZsetMembers.delete(member));
            }
            updateResult(currentResult);
            return;
        }

        const button = target.closest(".debug-row-edit, .debug-row-delete") as HTMLButtonElement | null;
        const bulkDeleteButton = target.closest(".debug-bulk-delete") as HTMLButtonElement | null;
        if (bulkDeleteButton) {
            if (currentResult?.type !== "zset" || selectedZsetMembers.size <= 0) {
                return;
            }

            void (async () => {
                const selectedMembers = [...selectedZsetMembers];
                const confirmed = await openConfirmDialog(
                    `Remove ${selectedMembers.length} selected zset members?`,
                    "Delete Selected Members",
                    "Delete",
                );
                if (!confirmed) {
                    return;
                }

                for (const member of selectedMembers) {
                    await mutateKey(
                        {
                            action: "remove-zset-member",
                            member,
                        },
                        { successLabel: "ZSET members removed" },
                    );
                    selectedZsetMembers.delete(member);
                }

                await inspectKey();
            })();
            return;
        }

        if (!button) {
            return;
        }

        const action = button.dataset.action;
        if (action === "edit-hash-field") {
            const field = button.dataset.field?.trim();
            const currentValue = button.dataset.value ?? "";
            if (!field) return;

            void (async () => {
                const values = await openFieldDialog(
                    "Edit Hash Field",
                    `Update the value for ${field}.`,
                    [{ name: "value", label: "Value", value: currentValue, inputType: "textarea" }],
                    "Save",
                );
                if (!values) {
                    return;
                }

                await mutateKey(
                    {
                        action: "set-hash-field",
                        field,
                        value: values.value ?? "",
                    },
                    { successLabel: "Hash field saved" },
                );
            })();
            return;
        }

        if (action === "edit-zset-member") {
            const currentMember = button.dataset.member?.trim();
            const currentScore = button.dataset.score ?? "0";
            if (!currentMember) return;

            void (async () => {
                const values = await openFieldDialog(
                    "Edit ZSET Member",
                    "Update the member name and score.",
                    [
                        { name: "member", label: "Member", value: currentMember, inputType: "text" },
                        { name: "score", label: "Score", value: currentScore, inputType: "number" },
                    ],
                    "Save",
                );
                if (!values) {
                    return;
                }

                const trimmedMember = String(values.member ?? "").trim();
                if (!trimmedMember) {
                    updateResult({ type: "error", key: keyInputEl.value.trim(), error: "ZSET member is required." });
                    inspectStatusEl.textContent = "Error";
                    return;
                }

                const nextScore = Number(values.score ?? "");
                if (!Number.isFinite(nextScore)) {
                    updateResult({ type: "error", key: keyInputEl.value.trim(), error: "ZSET score must be a valid number." });
                    inspectStatusEl.textContent = "Error";
                    return;
                }

                if (trimmedMember !== currentMember) {
                    await mutateKey(
                        {
                            action: "add-zset-member",
                            member: trimmedMember,
                            score: nextScore,
                        },
                        { successLabel: "ZSET member saved" },
                    );

                    await mutateKey(
                        {
                            action: "remove-zset-member",
                            member: currentMember,
                        },
                        { successLabel: "ZSET member saved" },
                    );
                    return;
                }

                await mutateKey(
                    {
                        action: "add-zset-member",
                        member: trimmedMember,
                        score: nextScore,
                    },
                    { successLabel: "ZSET member saved" },
                );
            })();
            return;
        }

        if (action === "delete-hash-field") {
            const field = button.dataset.field?.trim();
            if (!field) return;
            void mutateKey(
                {
                    action: "delete-hash-field",
                    field,
                },
                {
                    confirmMessage: `Delete hash field \"${field}\"?`,
                    successLabel: "Hash field deleted",
                },
            );
            return;
        }

        if (action === "remove-zset-member") {
            const member = button.dataset.member?.trim();
            if (!member) return;
            void mutateKey(
                {
                    action: "remove-zset-member",
                    member,
                },
                {
                    confirmMessage: `Remove member \"${member}\" from zset?`,
                    successLabel: "ZSET member removed",
                },
            );
        }
    });

    setStringEl.addEventListener("click", () => {
        void mutateKey(
            {
                action: "set-string",
                value: stringValueEl.value,
            },
            { successLabel: "String saved" },
        );
    });

    deleteKeyEl.addEventListener("click", () => {
        const key = keyInputEl.value.trim();
        if (!key) return;
        void mutateKey(
            {
                action: "delete-key",
            },
            {
                confirmMessage: `Delete key \"${key}\"? This cannot be undone.`,
                successLabel: "Key deleted",
            },
        );
    });

    setHashFieldEl.addEventListener("click", () => {
        void mutateKey(
            {
                action: "set-hash-field",
                field: hashFieldEl.value,
                value: hashValueEl.value,
            },
            { successLabel: "Hash field saved" },
        );
    });

    addZsetMemberEl.addEventListener("click", () => {
        void mutateKey(
            {
                action: "add-zset-member",
                member: zsetMemberEl.value,
                score: Number(zsetScoreEl.value),
            },
            { successLabel: "ZSET member saved" },
        );
    });

    removeZsetMemberEl.addEventListener("click", () => {
        const member = zsetRemoveMemberEl.value.trim();
        if (!member) return;
        void mutateKey(
            {
                action: "remove-zset-member",
                member,
            },
            {
                confirmMessage: `Remove member \"${member}\" from zset?`,
                successLabel: "ZSET member removed",
            },
        );
    });

    updateResult(null);
    applyTheme(getSavedTheme());
    void loadCatalog();
}
