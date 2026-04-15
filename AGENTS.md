# Project Guidelines

## Scope
- This workspace has two coupled parts:
  - `hidle/` (GameMaker project: GML scripts, objects, rooms, assets)
  - `devvit/sneaklegame/` (Devvit app: TypeScript client/server wrapper around GameMaker output)
- Prefer making code changes in the correct boundary. Game logic is usually in `scripts/` and `objects/`; web/server logic is in `devvit/sneaklegame/src/`.

## Architecture
- GameMaker builds are exported into `devvit/sneaklegame/src/client/public/` and then packaged by the Devvit app.
- Devvit app structure:
  - `devvit/sneaklegame/src/client/`: web client shell and splash UI
  - `devvit/sneaklegame/src/server/`: Express routes and Devvit actions
  - `devvit/sneaklegame/src/shared/`: shared types/contracts
- Keep interface contracts aligned across `src/client`, `src/server`, and `src/shared` when changing API payloads.

## Build and Test
- Run Node/Devvit commands from `devvit/sneaklegame/`.
- Install dependencies: `npm install`
- Type check: `npm run type-check`
- Build: `npm run build` (or `npm run build:client` / `npm run build:server`)
- Dev loop: `npm run dev` (watch client/server + Devvit playtest upload)
- Deploy commands require auth and intent:
  - `npm run login`
  - `npm run deploy`
  - `npm run launch`
- GameMaker builds are triggered from GameMaker IDE (Run/F5), not from CLI in this repo.

## Conventions
- GML naming patterns:
  - scripts: `scr_*`
  - objects: `obj_*`
  - fonts: `fnt_*`
  - internal helpers: `__*`
- In scripts that already contain GMLive guards, preserve that pattern (for example `if (live_call()) return live_result;`).
- Prefer small, focused edits and preserve existing style in both GML and TypeScript code.

## Generated Files and Safe Editing
- Do not hand-edit generated outputs unless explicitly requested:
  - `devvit/sneaklegame/src/client/public/**`
  - `devvit/sneaklegame/dist/**`
  - `tmp/**`
- Treat GameMaker metadata files (`*.yy`, `*.yyp`) carefully and avoid broad reformatting.

## Documentation
- Build/setup/troubleshooting: [devvit/sneaklegame/docs/HowToBuild.md](devvit/sneaklegame/docs/HowToBuild.md)
- Project/game overview: [devvit/sneaklegame/README.md](devvit/sneaklegame/README.md)
