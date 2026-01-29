📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.



## Prerequisites

- Docker and Docker Compose installed
- A CSV file named `./data/source/data_jobs.csv` in the project directory
- (Optional) `uv` installed for local execution: `pip install uv`

uv run python ingest_data.py --csv-file="./data/source/data_jobs.csv"

### 📖 Manual Installation

**1. Install uv:**
```bash
# On Linux/macOS
curl -LsSf https://astral.sh/uv/install.sh | sh

# On Windows (PowerShell)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Or with pip
pip install uv
```

**2. Create a virtual environment and sync dependencies:**
```bash
# uv automatically creates a .venv in the project directory
uv sync
```


## Containerized Option: Run with Docker Compose (Recommended)

### 1. Prepare the CSV file and run docker pull for the repository that provides uv
Place your CSV file in the project directory with the name ./data/source/data_jobs.csv
```bash
docker pull ghcr.io/astral-sh/uv:latest
```
### 2.a. Start the services: PostgreSQL database

```bash
docker-compose up -d pgdatabase pgadmin
```



### 2.a. Wait for PostgreSQL to be ready (about 10 seconds)
```bash
docker-compose logs -f pgdatabase
# Wait until you see: "database system is ready to accept connections"
```

### 2.c. Start the services: pgAdmin for database access (useful for verification)

```bash
docker-compose up -d pgadmin
```


### 3. Ejecutar la ingesta
```bash
docker-compose up ingest
```



Or everything in a single command:
```bash
docker-compose up
```

### 4. Verify the data

**Option A - pgAdmin (web interface):**
- Open http://localhost:8085
- Login: `admin@admin.com` / `root`
- Add server:
  - Host: `pgdatabase`
  - Port: `5432`
  - User: `root`
  - Password: `root`
  - Database: `data_jobs`

**Option B - psql (command line):**
```bash
docker exec -it <container-id-postgres> psql -U root -d data_jobs

#docker exec -it 10fccdab2178 psql -U root -d data_jobs

# Inside psql:
\dt                           # List tables
SELECT COUNT(*) FROM data_jobs;  # Count records
SELECT * FROM data_jobs LIMIT 5; # View first 5 records
```



### Restart from scratch
```bash
docker-compose down -v  # Removes volumes (deletes data)
docker-compose up -d
```

## Stop services

```bash
docker-compose down
```

To also delete the data:
```bash
docker-compose down -v
```




# ✅ Data Engineer Technical Assessment — Checklist

## Phase 1 — Ingestion

- [x] Create a **Python script** to read `data_jobs.csv` and **load it into a database table** (initial/raw table)
- [x] Use **PostgreSQL with Docker Compose** (preferred) **OR** use another DB (e.g., SQLite) **and justify the choice**
- [x] Correctly ingest **semi-structured columns** and store them in appropriate formats/data types:
  - [x] `job_skills` (lists)
  - [x] `job_type_skills` (dictionaries)

---

## Phase 2 — 3NF Relational Model (Core of the test)

- [/] **Design + implement** the transformation from the initial/raw table into a **3NF model**
- [ ] Use an implementation approach: **Python**, **dbt**, **raw SQL**, or a mix
- [x] Ensure the 3NF model includes:
  - [x] **Separate tables for main entities** (Jobs, Companies, Skills, Locations, etc.) with **foreign keys**
  - [x] Correct **many-to-many** relationship between **Jobs ↔ Skills**
  - [/] **Cleaning & standardization** to unify / clean the data

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
