-- Create the new database
CREATE DATABASE data_jobs_analytics;

-- Connect to the new database
\c data_jobs_analytics

-- =====================================================
-- DATA JOBS PIPELINE - PostgreSQL DDL (3NF) - UPDATED NAMES
-- =====================================================

-- =========================
-- DIMENSION TABLES
-- =========================

CREATE TABLE IF NOT EXISTS dim_companies (
    dim_company_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_name    VARCHAR(255) NOT NULL UNIQUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_locations (
    location_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location        VARCHAR(255),
    city            VARCHAR(120),
    state           VARCHAR(120),
    region          VARCHAR(120),
    country         VARCHAR(120),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_platforms (
    dim_platform_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    platform_name   VARCHAR(255) NOT NULL UNIQUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_schedule_types (
    dim_schedule_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    schedule_type_name   VARCHAR(255) NOT NULL UNIQUE,
    created_at           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_skills (
    dim_skill_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    skill_name       VARCHAR(255) NOT NULL UNIQUE,
    created_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_skill_categories (
    dim_category_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name    VARCHAR(255) NOT NULL UNIQUE,
    created_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_job_titles (
    dim_job_title_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    job_title_short     VARCHAR(255),
    created_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_salary_rates (
    dim_salary_rate_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dim_salary_rate_name   VARCHAR(255) NOT NULL UNIQUE,
    dim_created_at         TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_date       DATE NOT NULL UNIQUE,
    year            INTEGER NOT NULL,
    month           INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
    day             INTEGER NOT NULL CHECK (day BETWEEN 1 AND 31),
    quarter         INTEGER NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    day_of_week     INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    day_name        VARCHAR(20),
    month_name      VARCHAR(20),
    is_weekend      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS dim_time (
    time_id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_hour_hhmmss     TIME NOT NULL,
    hour_24              INTEGER NOT NULL CHECK (hour_24 BETWEEN 0 AND 23),
    hour_12              INTEGER NOT NULL CHECK (hour_12 BETWEEN 1 AND 12),
    am_pm                VARCHAR(2) NOT NULL CHECK (am_pm IN ('AM','PM')),
    minute               INTEGER NOT NULL CHECK (minute BETWEEN 0 AND 59),
    hhmm                 INTEGER NOT NULL CHECK (hhmm BETWEEN 0 AND 2359),
    hhmm_desc            VARCHAR(10),
    slot_time            VARCHAR(50),
    working_hour         BOOLEAN NOT NULL DEFAULT FALSE,
    peak_hour            BOOLEAN NOT NULL DEFAULT FALSE
);

-- =========================
-- FACT TABLE
-- =========================

CREATE TABLE IF NOT EXISTS fact_jobs_searched (
    fact_jobs_searched_id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    dim_job_title_id             INTEGER NOT NULL,
    dim_posting_location_id      INTEGER,
    dim_searching_location_id    INTEGER,
    dim_platform_id              INTEGER NOT NULL,
    dim_schedule_type_id         INTEGER,
    dim_company_id               INTEGER,
    dim_salary_rate_id           INTEGER,
    dim_posted_date_id           INTEGER,
    dim_posted_time_id           INTEGER,

    salary_year_avg              NUMERIC(12,2),
    salary_hour_avg              NUMERIC(12,2),

    job_work_from_home           BOOLEAN NOT NULL DEFAULT FALSE,
    job_no_degree_mention        BOOLEAN NOT NULL DEFAULT FALSE,
    job_health_insurance         BOOLEAN NOT NULL DEFAULT FALSE,

    created_at                   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                   TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_fact_job_title
        FOREIGN KEY (dim_job_title_id)
        REFERENCES dim_job_titles(dim_job_title_id),

    CONSTRAINT fk_fact_posting_location
        FOREIGN KEY (dim_posting_location_id)
        REFERENCES dim_locations(location_id),

    CONSTRAINT fk_fact_searching_location
        FOREIGN KEY (dim_searching_location_id)
        REFERENCES dim_locations(location_id),

    CONSTRAINT fk_fact_platform
        FOREIGN KEY (dim_platform_id)
        REFERENCES dim_platforms(dim_platform_id),

    CONSTRAINT fk_fact_schedule_type
        FOREIGN KEY (dim_schedule_type_id)
        REFERENCES dim_schedule_types(dim_schedule_type_id),

    CONSTRAINT fk_fact_company
        FOREIGN KEY (dim_company_id)
        REFERENCES dim_companies(dim_company_id),

    CONSTRAINT fk_fact_salary_rate
        FOREIGN KEY (dim_salary_rate_id)
        REFERENCES dim_salary_rates(dim_salary_rate_id),

    CONSTRAINT fk_fact_posted_date
        FOREIGN KEY (dim_posted_date_id)
        REFERENCES dim_date(date_id),

    CONSTRAINT fk_fact_posted_time
        FOREIGN KEY (dim_posted_time_id)
        REFERENCES dim_time(time_id)
);

-- Índices recomendados (joins y filtros comunes)
CREATE INDEX IF NOT EXISTS idx_fact_jobs_posted_date ON fact_jobs_searched(dim_posted_date_id);
CREATE INDEX IF NOT EXISTS idx_fact_jobs_company     ON fact_jobs_searched(dim_company_id);
CREATE INDEX IF NOT EXISTS idx_fact_jobs_platform    ON fact_jobs_searched(dim_platform_id);
CREATE INDEX IF NOT EXISTS idx_fact_jobs_title       ON fact_jobs_searched(dim_job_title_id);

-- =========================
-- BRIDGE TABLES
-- =========================

CREATE TABLE IF NOT EXISTS bridge_job_skills (
    fact_jobs_searched_id    INTEGER NOT NULL,
    dim_skill_id             INTEGER NOT NULL,
    skill_category_id        INTEGER,
    created_at               TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (fact_jobs_searched_id, dim_skill_id),

    CONSTRAINT fk_bjs_fact
        FOREIGN KEY (fact_jobs_searched_id)
        REFERENCES fact_jobs_searched(fact_jobs_searched_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_bjs_skill
        FOREIGN KEY (dim_skill_id)
        REFERENCES dim_skills(dim_skill_id),

    CONSTRAINT fk_bjs_skill_category
        FOREIGN KEY (skill_category_id)
        REFERENCES dim_skill_categories(dim_category_id)
);

CREATE TABLE IF NOT EXISTS bridge_skill_categories (
    dim_skill_id      INTEGER NOT NULL,
    dim_category_id   INTEGER NOT NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (dim_skill_id, dim_category_id),

    CONSTRAINT fk_bsc_skill
        FOREIGN KEY (dim_skill_id)
        REFERENCES dim_skills(dim_skill_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_bsc_category
        FOREIGN KEY (dim_category_id)
        REFERENCES dim_skill_categories(dim_category_id)
        ON DELETE CASCADE
);
