📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.

**[↑ Up](README.md)** | **[← Previous](03-ProjectStructure.md)** | **[Next →](05-ConceptualOlapModel.md)**

# ✅ Data Engineer Technical Assessment — Checklist

## Phase 1 — Ingestion

- [x] Create a **Python script** to read `data_jobs.csv` and **load it into a database table** (initial/raw table)
- [x] Use **PostgreSQL with Docker Compose** (preferred) **OR** use another DB (e.g., SQLite) **and justify the choice**
- [x] Correctly ingest **semi-structured columns** and store them in appropriate formats/data types:
  - [x] `job_skills` (lists)
  - [x] `job_type_skills` (dictionaries)

---

## Phase 2 — 3NF Relational Model (Core of the test)

- [ ] ***implementing*** **Design + implement** the transformation from the initial/raw table into a **3NF model**
- [ ] ***implementing*** Use an implementation approach: **Python**, **dbt**, **raw SQL**, or a mix
- [x] Ensure the 3NF model includes:
  - [x] **Separate tables for main entities** (Jobs, Companies, Skills, Locations, etc.) with **foreign keys**
  - [x] Correct **many-to-many** relationship between **Jobs ↔ Skills**
  - [ ] ***implementing*** **Cleaning & standardization** to unify / clean the data

---

## Required Deliverables

- [x] Provide an **ERD** (e.g., dbdiagram.io) **OR** a **`schema.sql`** with the DDL of your 3NF model
- [x] Submit as a **Git repository** with **clean + semantic commit history**
- [x] Include dependency management via **`requirements.txt`** *(Poetry/PDM/uv is a plus)*
- [ ] Add **tests**:
  - [ ] **Unit tests with pytest** for critical functions (transformation/extraction logic)
- [x] Create a **README.md** (documentation is a *fundamental deliverable*)

---

## Bonus / Extra Points (Nice-to-have)

- [ ] **Data quality tests** (dbt tests, or Pandera / Great Expectations in Python)
- [ ] **Security/configuration**: no hardcoded credentials, use **environment variables / .env**
- [ ] Add **logging** to track pipeline execution
- [ ] In README, include:
  - [ ] design decisions/justifications
  - [x] execution instructions
  - [ ] how to run tests
- [ ] **Orchestration** (Airflow/Prefect/Dagster) and **CI/CD** (GitHub Actions for linting/testing) *(not required to implement, but a plus)*

---

## Bonus — Conceptual OLAP Model (Star Schema)

In your README, **describe** how you would design a Star Schema from your 3NF model:

- [x] Fact table + **granularity**
- [x] Dimensions (e.g., `dim_company`, `dim_date`)
- [x] Measures (key numeric metrics)
- [x] Also explain how you would handle:
  - [x] `job_skills` using a **bridge table**
  - [x] multiple boolean flags using a **junk dimension**

---

## Submission

- [x] Deliverable: **link to your Git repository**


**[↑ Up](README.md)** | **[← Previous](03-ProjectStructure.md)** | **[Next →](05-ConceptualOlapModel.md)**

