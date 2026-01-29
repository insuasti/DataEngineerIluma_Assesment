📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.

**[↑ Up](README.md)** | **[← Previous](02-Checklist.md)** | **[Next →](04-DatabaseModelsAndDesign.md)**

#" 🗂️ Project Structure


```
.
├── Dockerfile              <- Dockerfile for the application
├── README.md               <- README file
├── data                    <- Data files 
│   ├── bronce
│   ├── gold
│   ├── silver
│   └── source
│       └── data_jobs.csv   <- Contain de initial data source
├── database                <- Dockerfile and Script DDL for database designed in 3NF with PostgreSQL 
│   ├── Dockerfile
│   └── init_sql
│       └── 01_create_3nf_db.sql  <- Script DDL for database designed in 3NF with PostgreSQL 
├── docker-compose.yaml     <- Docker Compose file
├── docs                    <- Documentation files
│   ├── 01-PrerrequisiteAndInstructions.md
│   ├── 02-Checklist.md
│   ├── 03-ProjectStructure.md
│   ├── 04-DatabaseModelsAndDesign.md
│   └── 05-ConceptualOlapModel.md
├── ingest_data.py          <- Python script to read data_jobs.csv and load it into a database table
├── pyproject.toml          <- Project configuration file
├── uv.lock                 <- uv lock file
└── .gitignore              <- Git ignore file

```

**[↑ Up](README.md)** | **[← Previous](02-Checklist.md)** | **[Next →](04-DatabaseModelsAndDesign.md)**


