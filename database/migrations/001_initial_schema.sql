-- Migration: 001_initial_schema
-- Created: 2026-03-12
-- Description: Initial database schema for Kinora MVP

-- This migration creates the complete initial schema.
-- See /database/schema.sql for the full reference.

BEGIN;

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Families (must come before users due to FK cycle resolution)
CREATE TABLE families (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name          VARCHAR(100)  NOT NULL,
    created_by    UUID          NOT NULL,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT now()
);

-- License Codes
CREATE TABLE license_codes (
    id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id         UUID        NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    code_hash         TEXT        NOT NULL UNIQUE,
    assigned_name     VARCHAR(100) NOT NULL,
    invited_by_name   VARCHAR(100) NOT NULL,
    relationship      VARCHAR(100),
    preferred_language CHAR(10)   NOT NULL DEFAULT 'en',
    birth_date        DATE,
    ai_context        TEXT,
    used_at           TIMESTAMPTZ,
    expires_at        TIMESTAMPTZ NOT NULL,
    revoked_at        TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_license_codes_family ON license_codes(family_id);
CREATE INDEX idx_license_codes_expires ON license_codes(expires_at) WHERE used_at IS NULL;

-- Users
CREATE TABLE users (
    id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id         UUID        NOT NULL REFERENCES families(id) ON DELETE RESTRICT,
    license_code_id   UUID        REFERENCES license_codes(id),
    email             VARCHAR(320) NOT NULL UNIQUE,
    password_hash     TEXT        NOT NULL,
    display_name      VARCHAR(100) NOT NULL,
    avatar_url        TEXT,
    preferred_language CHAR(10)   NOT NULL DEFAULT 'en',
    role              VARCHAR(20) NOT NULL DEFAULT 'member'
                        CHECK (role IN ('admin', 'member')),
    is_active         BOOLEAN     NOT NULL DEFAULT true,
    last_seen_at      TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE families
    ADD CONSTRAINT fk_families_created_by
    FOREIGN KEY (created_by) REFERENCES users(id) DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX idx_users_family ON users(family_id);
CREATE INDEX idx_users_email ON users(email);

-- Refresh Tokens
CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  TEXT        NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ NOT NULL,
    revoked_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);

COMMIT;
