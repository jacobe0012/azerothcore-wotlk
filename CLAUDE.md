# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AzerothCore is an open-source MMORPG server emulator for World of Warcraft patch 3.3.5a (Wrath of the Lich King). It's a C++ project built with CMake, using MySQL for data storage. Licensed under GNU GPL v2.

## Build Commands

### Configure and build (out-of-source build required)

- Skip building unless explicitly requested.

```bash
# Create build directory and configure
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DSCRIPTS=static -DMODULES=static

# Build (use appropriate core count)
make -j$(nproc)
make install
```

### Key CMake options

- `SCRIPTS`: none, static, dynamic, minimal-static, minimal-dynamic (default: static)
- `MODULES`: none, static, dynamic (default: static)
- `APPS_BUILD`: none, all, auth-only, world-only (default: all)
- `TOOLS_BUILD`: none, all, db-only, maps-only (default: none)
- `BUILD_TESTING`: Enable unit tests (default: OFF)
- `USE_COREPCH` / `USE_SCRIPTPCH`: Precompiled headers (default: ON)

### Unit tests

```bash
# Configure with testing enabled
cmake .. -DBUILD_TESTING=ON
make -j$(nproc)

# Run tests
./src/test/unit_tests
# or
ctest
```

Tests use Google Test and live in `src/test/`. The test binary links against the `game` library.

## Architecture

### Two server executables
- **authserver** (`src/server/apps/authserver/`): Handles authentication and realm selection (port 3724)
- **worldserver** (`src/server/apps/worldserver/`): Main game server handling all gameplay (port 8085)

### Source layout (`src/`)

- **`src/common/`** - Shared libraries: networking (Asio), cryptography, configuration, logging, threading, collision detection, utilities
- **`src/server/game/`** - Core game logic (~52 subsystems), the heart of the worldserver
- **`src/server/scripts/`** - Content scripts (bosses, spells, commands, instances)
- **`src/server/database/`** - Database abstraction layer and schema updater
- **`src/server/shared/`** - Code shared between auth and world servers (packets, network, realm definitions)
- **`src/test/`** - Unit tests (Google Test)

### Key game subsystems (`src/server/game/`)

- **Entities/** - Core game objects: `Player`, `Creature`, `Unit`, `Item`, `GameObject`
- **Spells/** - Spell mechanics, aura system, spell effects
- **Maps/** - Map management, grid system, instancing
- **Handlers/** - Client packet handlers (one file per system: `MovementHandler.cpp`, `SpellHandler.cpp`, etc.). These are methods on `WorldSession`
- **AI/** - Creature AI framework
- **Scripting/** - Script system with typed base classes (`ScriptObject` subclasses: `CreatureScript`, `SpellScript`, `InstanceMapScript`, `GameObjectScript`, `CommandScript`, etc.)
- **Server/** - `WorldSession` (per-player connection), `World` (global state), opcode definitions

### Scripting system

Scripts follow a registration pattern:
1. Define a class inheriting from `SpellScript`, `CreatureScript`, etc.
2. Implement an `AddSC_*()` function that calls `RegisterSpellScript(ClassName)` (or similar)
3. The `AddSC_*()` is declared and called from the regional `*_script_loader.cpp`
4. Script loaders per region: `spells_script_loader.cpp`, `eastern_kingdoms_script_loader.cpp`, `northrend_script_loader.cpp`, etc.
5. Spell script files are organized by class: `spell_dk.cpp`, `spell_mage.cpp`, `spell_generic.cpp`, etc.

### Three databases
- **acore_auth** - Accounts, realm list, bans (`data/sql/base/db_auth/`)
- **acore_characters** - Character data, inventories, progress (`data/sql/base/db_characters/`)
- **acore_world** - Game content: creatures, items, quests, spells, loot (`data/sql/base/db_world/`)

- SQL updates go in `data/sql/updates/pending_*` with separate subdirectories per database until pull request is merged. Pending SQL files are assigned random names.
- SQL updates go in `data/sql/updates/` with separate subdirectories per database after their pull request is merged.
- SQL files outside the `data/sql/updates/pending_*` folders should never be updated.

### Module system

External modules are loaded from the `modules/` directory. Each module is a subdirectory with its own `CMakeLists.txt`. Disable specific modules with `-DDISABLED_AC_MODULES="mod1;mod2"`. Module skeleton: https://github.com/azerothcore/skeleton-module/

### Dependencies

Bundled in `deps/`: boost, MySQL client, OpenSSL, zlib, recastnavigation (pathfinding), g3dlite (geometry), fmt, argon2, jemalloc, and others.

## Commit Message Format

Uses Conventional Commits:
```
Type(Scope/Subscope): Short description (max 50 chars)
```

- **Types**: feat, fix, refactor, style, docs, test, chore
- **Scopes**: Core (C++ changes), DB (SQL changes)
- **Examples**: `fix(Core/Spells): Fix damage calculation for Fireball`, `fix(DB/SAI): Missing spell to NPC Hogger`

## Code Style

- 4-space indentation for C++ (no tabs)
- 2-space indentation for JSON, YAML, shell scripts
- UTF-8 encoding, LF line endings
- Max 80 character line length
- No braces around single-line statements
- Use {} to parse variables into output instead of %u etc.
- CI enforces code style checks and compiles with `-Werror`

## PR Requirements

- AI tool usage must be disclosed in PRs
- In-game testing expected
- Changes to generic code require regression testing of related systems

## Fork / Branch Setup

This working copy is a **personal fork** of the upstream playerbots repo. Two remotes, two branches — they have distinct purposes, don't mix them up.

### Remotes

- `origin` → `https://github.com/jacobe0012/azerothcore-wotlk.git` (the user's fork)
- `upstream` → `https://github.com/mod-playerbots/azerothcore-wotlk.git` (original author)

### Branches

- `main` → tracks `upstream/Playerbot`. Pure mirror of original author. **Never commit user work here.** Used only for pulling upstream updates.
- `dev` → tracks `origin/dev`. User's work branch. All user changes (including custom SQL, configs, submodule pin) live here.

### Syncing upstream into dev
```bash
git checkout main && git pull              # pull original's latest into main
git checkout dev && git merge main         # bring updates into dev
git push                                   # push to user's fork
```

## Submodule: mod-playerbots

`modules/mod-playerbots/` is a **git submodule** pointing at `https://github.com/mod-playerbots/mod-playerbots.git`. It is pinned to a specific commit in `.gitmodules` and is NOT part of the upstream repo's tree (upstream ignores `/modules/*`).

### Cloning this fork fresh
```bash
git clone --recurse-submodules https://github.com/jacobe0012/azerothcore-wotlk.git
# Or after a plain clone:
git submodule update --init --recursive
```

### Updating the module to its latest master
```bash
cd modules/mod-playerbots && git pull origin master && cd ../..
git add modules/mod-playerbots
git commit -m "chore(Module): Update mod-playerbots"
git push
```

## Files Force-Tracked Despite .gitignore

Upstream's `.gitignore` excludes these, but they are force-added on the `dev` branch to persist user's local setup. Do NOT remove them, and do NOT edit `.gitignore` to "fix" the warnings — they are intentionally tracked via `git add -f`:

| Path | Purpose |
|------|---------|
| `data/sql/custom/db_world/zhCN/` | Chinese localization SQL (user-provided) |
| `docker-compose.override.yml` | Local Docker override (mounts `modules/` read-only into worldserver) |
| `env/dist/etc/authserver.conf` | Auth server config (Docker overrides DB info via env vars) |
| `env/dist/etc/worldserver.conf` | World server config (Docker overrides DB info via env vars) |
| `env/dist/etc/dbimport.conf` | DB import config |
| `env/dist/etc/modules/playerbots.conf.dist` | Playerbots module config template |

### Still ignored (do not commit)

- `.claude/`, `.env` — tool config / secrets
- `env/dist/logs/*.log` — runtime logs
- Root-level `*.conf.dist` — build-generated templates

## Docker workflow (this fork)

- Start everything: `docker compose up -d --build`
- Restart services only (no data touched): `docker compose restart ac-worldserver ac-authserver`
- Reload client data volume (~3GB, destroys `ac-client-data` volume): stop worldserver, `docker volume rm azerothcore-playerbots_ac-client-data`, then `docker compose up -d`
- Reset SQL databases (destroys all character/world/auth data): stop servers, `docker volume rm azerothcore-playerbots_ac-database`, then `docker compose up -d`

The real DB root password lives in `.env` (ignored). Conf files use placeholder `acore/acore` which Docker overrides at runtime via `AC_LOGIN_DATABASE_INFO` etc. env vars in `docker-compose.yml`.
