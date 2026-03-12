-- =============================================================
-- KINORA — Database Schema
-- PostgreSQL 15+
-- =============================================================
-- Run migrations in order from the migrations/ directory.
-- This file is a complete reference of the target schema.
-- =============================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "postgis";    -- for location queries

-- =============================================================
-- FAMILIES
-- =============================================================
CREATE TABLE families (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name          VARCHAR(100)  NOT NULL,
    created_by    UUID          NOT NULL,  -- references users.id (set after users table)
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT now()
);

-- =============================================================
-- LICENSE CODES
-- =============================================================
CREATE TABLE license_codes (
    id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id         UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    code_hash         TEXT        NOT NULL UNIQUE,   -- bcrypt/argon2 hash of plaintext code
    assigned_name     VARCHAR(100) NOT NULL,
    invited_by_name   VARCHAR(100) NOT NULL,
    relationship      VARCHAR(100),
    preferred_language CHAR(10)   NOT NULL DEFAULT 'en',
    birth_date        DATE,
    ai_context        TEXT,                           -- pre-loaded AI personality context
    used_at           TIMESTAMPTZ,
    expires_at        TIMESTAMPTZ NOT NULL,
    revoked_at        TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_license_codes_family ON license_codes(family_id);
CREATE INDEX idx_license_codes_expires ON license_codes(expires_at) WHERE used_at IS NULL;

-- =============================================================
-- USERS
-- =============================================================
CREATE TABLE users (
    id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id         UUID        NOT NULL REFERENCES families(id) ON DELETE RESTRICT,
    license_code_id   UUID        REFERENCES license_codes(id),
    email             VARCHAR(320) NOT NULL UNIQUE,
    password_hash     TEXT        NOT NULL,              -- argon2id hash
    display_name      VARCHAR(100) NOT NULL,
    avatar_url        TEXT,
    preferred_language CHAR(10)   NOT NULL DEFAULT 'en',
    role              VARCHAR(20) NOT NULL DEFAULT 'member'  -- 'admin' | 'member'
                        CHECK (role IN ('admin', 'member')),
    is_active         BOOLEAN     NOT NULL DEFAULT true,
    last_seen_at      TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE families
    ADD CONSTRAINT fk_families_created_by FOREIGN KEY (created_by) REFERENCES users(id);

CREATE INDEX idx_users_family ON users(family_id);
CREATE INDEX idx_users_email ON users(email);

-- =============================================================
-- REFRESH TOKENS
-- =============================================================
CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  TEXT        NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ NOT NULL,
    revoked_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);

-- =============================================================
-- FAMILY TREE — PERSONS (includes non-registered members)
-- =============================================================
CREATE TABLE persons (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id     UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    user_id       UUID        REFERENCES users(id),     -- null if not registered
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    maiden_name   VARCHAR(100),
    birth_date    DATE,
    death_date    DATE,
    is_deceased   BOOLEAN     NOT NULL DEFAULT false,
    photo_url     TEXT,
    location      VARCHAR(200),
    bio           TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_persons_family ON persons(family_id);

-- Relationships between persons (parent-child, spouse)
CREATE TABLE person_relationships (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    person_id       UUID        NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    related_id      UUID        NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    relationship    VARCHAR(20) NOT NULL
                      CHECK (relationship IN ('parent', 'child', 'spouse')),
    UNIQUE (person_id, related_id, relationship)
);

-- =============================================================
-- MESSAGES
-- =============================================================
CREATE TABLE conversations (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    type        VARCHAR(20) NOT NULL DEFAULT 'group'
                  CHECK (type IN ('family_hub', 'direct', 'group')),
    name        VARCHAR(100),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE conversation_members (
    conversation_id UUID    NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    user_id         UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE messages (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID        NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id       UUID        NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    type            VARCHAR(20) NOT NULL DEFAULT 'text'
                      CHECK (type IN ('text', 'image', 'video', 'audio', 'file', 'notice')),
    content         TEXT,
    media_url       TEXT,
    reply_to_id     UUID        REFERENCES messages(id),
    is_deleted      BOOLEAN     NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);

CREATE TABLE message_reactions (
    message_id  UUID        NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    emoji       VARCHAR(10) NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (message_id, user_id, emoji)
);

-- =============================================================
-- LOCATION SHARING
-- =============================================================
CREATE TABLE user_locations (
    user_id         UUID        PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    -- PostGIS geography point (longitude, latitude)
    coordinates     GEOGRAPHY(POINT, 4326),
    city            VARCHAR(100),
    country         VARCHAR(100),
    sharing_level   VARCHAR(10) NOT NULL DEFAULT 'city'
                      CHECK (sharing_level IN ('precise', 'city', 'country', 'hidden')),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================================
-- MEDIA / MEMORY VAULT
-- =============================================================
CREATE TABLE media_items (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id       UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    uploaded_by     UUID        NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    type            VARCHAR(10) NOT NULL CHECK (type IN ('photo', 'video', 'audio')),
    storage_key     TEXT        NOT NULL,   -- S3 / GCS object key
    thumbnail_key   TEXT,
    original_name   TEXT        NOT NULL,
    mime_type       VARCHAR(100),
    size_bytes      BIGINT,
    ai_tags         TEXT[],                 -- AI-generated tags
    caption         TEXT,
    taken_at        TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_media_family ON media_items(family_id, created_at DESC);

CREATE TABLE albums (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    name        VARCHAR(100) NOT NULL,
    cover_id    UUID        REFERENCES media_items(id),
    created_by  UUID        NOT NULL REFERENCES users(id),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE album_media (
    album_id    UUID    NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
    media_id    UUID    NOT NULL REFERENCES media_items(id) ON DELETE CASCADE,
    added_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (album_id, media_id)
);

-- =============================================================
-- RECIPES
-- =============================================================
CREATE TABLE recipes (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    created_by  UUID        NOT NULL REFERENCES users(id),
    title       VARCHAR(200) NOT NULL,
    description TEXT,
    ingredients JSONB       NOT NULL DEFAULT '[]',
    steps       JSONB       NOT NULL DEFAULT '[]',
    tags        TEXT[],
    photo_url   TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_recipes_family ON recipes(family_id);

-- =============================================================
-- MEMORIAL PAGES
-- =============================================================
CREATE TABLE memorials (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    person_id   UUID        NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    tribute     TEXT,
    created_by  UUID        NOT NULL REFERENCES users(id),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================================
-- PRAYER / SUPPORT REQUESTS
-- =============================================================
CREATE TABLE prayer_requests (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(200) NOT NULL,
    body        TEXT        NOT NULL,
    is_resolved BOOLEAN     NOT NULL DEFAULT false,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================================
-- NOTICES
-- =============================================================
CREATE TABLE notices (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id   UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    created_by  UUID        NOT NULL REFERENCES users(id),
    type        VARCHAR(20) NOT NULL DEFAULT 'general'
                  CHECK (type IN ('general', 'urgent', 'event', 'birthday', 'memorial')),
    title       VARCHAR(200) NOT NULL,
    body        TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notices_family ON notices(family_id, created_at DESC);

-- =============================================================
-- RUGBY TEAM PREFERENCES
-- =============================================================
CREATE TABLE user_rugby_preferences (
    user_id     UUID        PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    team_id     VARCHAR(50) NOT NULL,
    team_name   VARCHAR(100) NOT NULL,
    primary_color   CHAR(7) NOT NULL DEFAULT '#000000',  -- hex color
    secondary_color CHAR(7) NOT NULL DEFAULT '#FFFFFF',
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
