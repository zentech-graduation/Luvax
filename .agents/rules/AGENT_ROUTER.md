# Agent Router

## How to Use This File

Before any implementation task, determine your task scope and follow the routing table below.

## Routing Table

| Task Scope | Required Reading (in order) |
|------------|----------------------------|
| Backend only | 1. This file  2. GLOBAL_RULES.md (root)  3. Luvax/.claude/rules/base.md  4. Luvax/.claude/rules/struct.md  5. Luvax/docs/modules/GLOBAL_RULES.md  6. Luvax/docs/modules/{module}/DATA_RULES.md (relevant module) |
| Frontend only | 1. This file  2. GLOBAL_RULES.md (root)  3. app-fe/.claude/rules/GLOBAL_RULES.md  4. app-fe/.claude/rules/STRUCT.md |
| Full-stack (BE + FE) | 1. This file  2. GLOBAL_RULES.md (root)  3. All BE rules above  4. All FE rules above |
| Infrastructure / CI | 1. This file  2. GLOBAL_RULES.md (root)  3. STRUCT.md (root) |
| Database migration | 1. This file  2. GLOBAL_RULES.md (root)  3. Luvax/.claude/rules/base.md  4. Luvax/docs/modules/GLOBAL_RULES.md  5. Luvax/docs/modules/{module}/DATA_RULES.md |

## Scope Detection Rules

- Task mentions Spring, JPA, RabbitMQ, Redis, Flyway, PostgreSQL, REST endpoint → **Backend**
- Task mentions component, page, route, CSS, UI, React, Vite, Zustand, store → **Frontend**
- Task mentions API contract, DTO shape, request/response format → **Full-stack**
- Task mentions GitHub Actions, Docker, .env, infrastructure → **Infrastructure**
- Task mentions `V{n}__*.sql`, schema, migration, trigger, index → **Database migration**

## Commit Routing

- Changes inside `Luvax/` → commit and push to the BE repository only
- Changes inside `app-fe/` → commit and push to the FE repository only
- Changes to root-level rule files → commit to the root aggregator repository only
- Never mix sub-project changes with root-level changes in a single commit
