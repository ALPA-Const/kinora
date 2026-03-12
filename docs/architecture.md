# Kinora — Architecture Overview

## System Architecture

Kinora is a private family communication platform built as a Node.js monorepo with a Next.js frontend and Express API backend.

```
┌─────────────────────────────────────────────────────┐
│                  Client Applications                 │
│                                                     │
│   ┌─────────────────────┐  ┌────────────────────┐  │
│   │   Next.js Web App   │  │  React Native App  │  │
│   │  (frontend/)        │  │  (mobile/ — future)│  │
│   └──────────┬──────────┘  └────────┬───────────┘  │
└──────────────┼────────────────────── ┼──────────────┘
               │ HTTPS / WSS           │
               ▼                       ▼
┌─────────────────────────────────────────────────────┐
│                  API Server (backend/)               │
│                                                     │
│   Express + TypeScript                              │
│   ├── REST API  (HTTP/HTTPS)                        │
│   ├── WebSocket (Socket.io — real-time chat,        │
│   │             location, presence)                 │
│   └── WebRTC   (signalling for voice/video calls)   │
│                                                     │
│   Middleware: helmet, cors, rate-limit, auth JWT    │
└──────┬────────────────────┬───────────────────────┬─┘
       │                    │                       │
       ▼                    ▼                       ▼
┌──────────────┐  ┌─────────────────┐  ┌────────────────────┐
│  PostgreSQL  │  │     Redis       │  │  File Storage      │
│  (primary DB)│  │  (sessions,     │  │  (S3 / GCS)        │
│              │  │   cache, pubsub)│  │  Media, photos,    │
│  PostGIS for │  │                 │  │  videos, audio     │
│  location    │  │                 │  └────────────────────┘
└──────────────┘  └─────────────────┘
```

## Core Services

| Service | Technology | Purpose |
|---------|-----------|---------|
| Web Frontend | Next.js 14 | Main browser application |
| Mobile App | React Native | iOS + Android (future phase) |
| API Server | Express + TypeScript | REST API + WebSocket |
| Database | PostgreSQL 15 + PostGIS | Primary data store |
| Cache | Redis 7 | Sessions, rate-limit, pub/sub |
| Real-time | Socket.io | Chat, location, presence |
| Video/Voice | WebRTC + Twilio/Agora | Calls |
| Translation | Google Cloud Translation | Real-time call translation |
| AI/LLM | OpenAI API | Memory vault tagging, On This Day |
| Media | AWS S3 | Photos, videos, voice memos |
| Email | SendGrid | Notification emails |
| Push | FCM + APNS | Mobile push notifications |

## Authentication Flow

```
User ──[enters license code]──► POST /api/v1/auth/validate-code
                                         │
                              ┌──────────▼──────────┐
                              │  Rate limited (10/hr) │
                              │  Validate format      │
                              │  Look up code hash    │
                              │  Check expiry/revoked │
                              └──────────┬────────────┘
                                         │ Profile data
                                         ▼
User ──[completes registration]──► POST /api/v1/auth/register
                                         │
                              ┌──────────▼────────────┐
                              │  Hash password (Argon2)│
                              │  Create user record    │
                              │  Mark code as used     │
                              │  Issue JWT + refresh   │
                              └──────────┬─────────────┘
                                         │
                                 ┌───────▼──────┐
                                 │  Access JWT  │  (15 min)
                                 │  Refresh JWT │  (7 days, httpOnly cookie)
                                 └──────────────┘
```

## License Code System

Format: `KINORA-[NAME]-[YEAR]-[SUFFIX]`  
Example: `KINORA-MARIA-2024-7X9K`

Security properties:
- Suffix generated with CSPRNG
- Only the hash is stored in the database
- Codes expire in 30 days if unused
- Rate limited: 10 validation attempts per hour per IP
- Single-use: once consumed, immediately invalidated

## Real-time Architecture

Socket.io rooms map to:
- `family:{familyId}` — family-wide presence and notices
- `chat:{conversationId}` — per-conversation messages
- `location:{familyId}` — live location updates

Authentication: every socket connection must present a valid short-lived token in `socket.handshake.auth.token`.

## Directory Structure

```
kinora/
├── backend/
│   ├── src/
│   │   ├── config/         Database, Redis, environment config
│   │   ├── middleware/      Auth, rate-limit, error handling, logging
│   │   ├── models/          TypeScript interfaces/types for DB entities
│   │   ├── routes/          Express route handlers
│   │   ├── services/        Business logic (LicenseCode, Auth, Chat, etc.)
│   │   └── utils/           Logger, helpers
│   └── __tests__/           Jest integration tests
├── frontend/
│   └── src/
│       ├── app/             Next.js App Router pages
│       ├── components/      Reusable React components
│       ├── hooks/           Custom React hooks
│       ├── lib/             API client, utilities
│       └── types/           Shared TypeScript types
├── database/
│   ├── schema.sql           Complete target schema (reference)
│   └── migrations/          Numbered SQL migration files
├── docs/                    Architecture and developer docs
└── .github/workflows/       CI/CD pipelines
```
