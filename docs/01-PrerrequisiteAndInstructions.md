📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.

**[↑ Up](README.md)** | **[← Previous](README.md)** | **[Next →](02-Checklist.md)**


## Prerequisites 

- Docker and Docker Compose installed
- A CSV file named `./data/source/data_jobs.csv` in the project directory
- (Optional) `uv` installed for local execution: `pip install uv`

uv run python ingest_data.py --csv-file="./data/source/data_jobs.csv"

### 📖 Manual Installation - Execution instructions

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


**[↑ Up](README.md)** | **[← Previous](README.md)** | **[Next →](02-Checklist.md)**