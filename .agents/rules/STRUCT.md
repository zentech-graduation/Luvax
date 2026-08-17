# Workspace Structure

## Section 1 — Workspace Layout

```text
<root>/
├── .claude/
│   └── rules/                # Agent rules — workspace scope
│       ├── WORKSPACE.md
│       ├── AGENT_ROUTER.md
│       ├── STRUCT.md
│       └── GLOBAL_RULES.md
├── .agents/
│   └── rules/                # Mirror of .claude/rules/ for Codex/Agents SDK
│       ├── WORKSPACE.md
│       ├── AGENT_ROUTER.md
│       ├── STRUCT.md
│       └── GLOBAL_RULES.md
├── .gitmodules               # Submodule declarations (path + remote URL)
├── .gitignore                # Root-level ignores (no source-code ignores)
├── git-setup.sh              # Setup script — review before running
├── backend/                  # Backend sub-project (Spring Boot)
└── frontend/                 # Frontend sub-project (React + Vite)
```

### Git Submodule Configuration

| Submodule | Path | Remote | Branch |
|-----------|------|--------|--------|
| Backend | backend/ | https://github.com/zentech-graduation/backend.git | main |
| Frontend | frontend/ | https://github.com/zentech-graduation/frontend.git | main |

---

## Section 2 — Backend Overview

Full detail: `backend/.claude/rules/struct.md`

### Technology Stack

| Component | Value |
|-----------|-------|
| Language | Java 21 (virtual threads enabled) |
| Framework | Spring Boot 4.0.6 |
| Database | PostgreSQL |
| Cache | Redis |
| Message Broker | RabbitMQ |
| Build | Maven (`./mvnw`) |
| Migrations | Flyway (18 migrations, V01–V18) |
| Resilience | Resilience4j (Spring Cloud 2025.1.1) |
| Security | Spring Security 6, JWT |
| ORM | Spring Data JPA / Hibernate |
| Formatting | Spotless 2.46.1 (Google AOSP) |
| Testing | JUnit 5, Testcontainers |

### Application Purpose

Instagram-style social network: profiles, follow graph, photo/video/carousel posts, likes/saves,
nested comments, 24-hour stories, 1-1 and group DMs, hashtags, ranked feed.
Architecture: **Modular Monolith**.

### Module Roster

| Module | Status |
|--------|--------|
| `auth` | Implemented |
| `mail` | Implemented |
| `users`, `social`, `media`, `post`, `comment` | Empty scaffolds |
| `hashtag`, `story`, `notification`, `message` | Empty scaffolds |
| `report`, `admin`, `recommendation` | Empty scaffolds |

### Infrastructure Services

- **PostgreSQL** (docker-compose): canonical data store; 18 Flyway migrations
- **Redis** (docker-compose): token blacklist, refresh tokens, rate limiting
- **RabbitMQ** (docker-compose): async event delivery (no queues defined yet)
- Swagger / OpenAPI at `/api-docs` (dev profile only)

### Flyway Migrations

V01 extensions/enums → V02 users/auth → V03 settings/push → V04 social → V05 media →
V06 posts → V07 comments → V08 hashtags → V09 stories → V10 notifications → V11 messages →
V12 reports → V13 admin → V14 recommendation → V15 indexes → V16 triggers/functions →
V17 views → V18 metadata config tables

### Redis Key Patterns

| Pattern | TTL | Purpose |
|---------|-----|---------|
| `auth:token:email-verification:{sha256}` | 24h | Email verification token |
| `auth:token:password-reset:{sha256}` | 15m | Password reset token |
| `auth:blacklist:jti:{jti}` | remaining access token lifetime | Token blacklist |
| `app:{domain}:{id}` | varies | Single entries (planned) |
| `app:{domain}:list` | varies | Collections (planned) |

---

## Section 3 — Frontend Overview

Full detail: `frontend/.claude/rules/struct.md`

### Technology Stack

| Component | Value |
|-----------|-------|
| Framework | React 19 |
| Build Tool | Vite 8 |
| Package Manager | npm |
| Styling | Tailwind CSS v4 (`@tailwindcss/vite`) |
| UI Components | shadcn/ui + Radix primitives |
| Server State | TanStack Query v5 |
| Global Client State | Zustand v5 (with `persist` middleware) |
| HTTP Client | Axios v1 (`src/api/axiosClient.js`) |
| Routing | React Router DOM v7 (centralized config router) |
| Forms | React Hook Form v7 + Zod v4 |
| Language | JavaScript (no TypeScript; jsconfig.json for IDE support) |

### Source Tree

```text
src/
├── api/            # Axios client instances and interceptors
├── assets/         # Static assets
├── components/
│   ├── common/     # Route guards, shared pages (ProtectedRoute, GuestRoute, etc.)
│   └── ui/         # shadcn/ui primitives (Button, Input, Card, Label)
├── config/         # App constants, route paths, STALE_TIME, HTTP_STATUS
├── context/        # Reserved for React context providers
├── features/
│   ├── auth/       # Most complete slice — hooks, services, store, utils, components
│   ├── dashboard/  # Authenticated dashboard stub
│   └── luvax/      # Main app shell screens (Feed, Explore, Profile, Story, etc.)
├── hooks/          # Shared reusable hooks
├── pages/          # Route-level pages not yet in a feature module
├── routes/         # Central React Router config (createBrowserRouter)
├── services/       # Shared API infrastructure (re-exports axiosClient)
├── store/          # Global Zustand stores (useAuthStore)
└── utils/          # Generic helpers (cn, helpers)
```

### Key Dependencies with Versions

| Package | Version | Role |
|---------|---------|------|
| react | ^19.2.6 | UI framework |
| react-router-dom | ^7.15.1 | Client-side routing |
| @tanstack/react-query | ^5.100.11 | Server state / caching |
| zustand | ^5.0.13 | Global client state |
| axios | ^1.16.1 | HTTP client |
| tailwindcss | ^4.3.0 | Utility CSS |
| react-hook-form | ^7.76.0 | Form state management |
| zod | ^4.4.3 | Schema validation |
| lucide-react | ^1.16.0 | Icon set |

### Key Scripts

```bash
npm run dev        # Start Vite dev server (via scripts/dev-server.mjs)
npm run build      # Production build
npm run lint       # ESLint
npm run preview    # Preview production build
```

### Environment Variable Prefix

All FE environment variables use the `VITE_` prefix (Vite convention).
See `frontend/.env.example` for the full list.

---

## Section 4 — Integration Points

### How FE Calls BE

- API base URL: configured via `VITE_API_URL` env var (default: `http://localhost:8080/api/v1`)
- In dev mode, Vite proxies `/api/v1` to the BE (configured in `frontend/vite.config.js`)
- Auth header: `Authorization: Bearer <accessToken>` injected by `axiosClient` request interceptor
- Token refresh: automatic on 401 — `axiosClient` intercepts, calls `/auth/refresh`, replays original request
- Public (unauthenticated) calls use `publicClient`; authenticated calls use `axiosClient`

### Auth Token Handling

| Token | Storage | Notes |
|-------|---------|-------|
| Access token | In-memory (Zustand, not persisted) | Short-lived; cleared on tab close |
| Refresh token | In-memory (Zustand, not persisted) | Planned migration to HttpOnly cookie |
| User + isAuthenticated | `localStorage` via Zustand persist | Key: `luvax-auth-session` |

### Shared Contracts

- No shared TypeScript types (project uses plain JavaScript on FE side)
- BE OpenAPI spec at `http://localhost:8080/api-docs` (dev profile) is the authoritative contract
- All BE API responses follow `ApiResponse<T>` wrapper shape; FE consumers must handle this envelope

### OAuth2

- Google OAuth flow initiated via `VITE_GOOGLE_AUTH_URL` (points to BE)
- Callback handled at FE route `/oauth2/callback` (`OAuthCallbackPage.jsx`)
- BE success handler redirects browser back to FE with `?code=...` query param
