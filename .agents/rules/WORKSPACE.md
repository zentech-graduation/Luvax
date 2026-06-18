# Workspace Overview

## Structure

This is a monorepo workspace containing two independent sub-projects managed as Git Submodules.

| Sub-project | Path | Tech Stack | Own Rules |
|-------------|------|------------|-----------|
| Backend     | Luvax/ | Spring Boot 4, Java 21, PostgreSQL | Luvax/.claude/rules/ |
| Frontend    | app-fe/ | React 19, Vite 8, Tailwind CSS v4 | app-fe/.claude/rules/ |

## Git Model

- This root repo is an **aggregator only**. It contains no source code.
- All business logic commits go to the sub-project repos via their submodule directories.
- The root repo tracks: agent configuration, STRUCT.md, and submodule commit pointers only.
- Never commit source code changes to the root repo.

## Agent Working Instructions

1. Read AGENT_ROUTER.md to determine which sub-project rules to load for your task.
2. For BE tasks: navigate to Luvax/ and read its .claude/rules/ before acting.
3. For FE tasks: navigate to app-fe/ and read its .claude/rules/ before acting.
4. For cross-cutting tasks: read both sub-project rule sets.
5. For any DB migration or data layer change: re-read GLOBAL_RULES.md in this directory.
