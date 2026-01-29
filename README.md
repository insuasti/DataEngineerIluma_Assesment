# Job Data Ingestion Pipeline

Este proyecto ingesta datos de trabajos desde un archivo CSV local hacia PostgreSQL usando Docker y `uv`.

## Prerequisitos

- Docker y Docker Compose instalados
- Archivo CSV con nombre `./data/source/data_jobs.csv` en el directorio del proyecto
- (Opcional) `uv` instalado para ejecución local: `pip install uv`


uv run python ingest_data.py --csv-file="./data/source/data_jobs.csv"

### 📖 Instalación Manual

**1. Instalar uv:**
```bash
# En Linux/macOS
curl -LsSf https://astral.sh/uv/install.sh | sh

# En Windows (PowerShell)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# O con pip
pip install uv
```

**2. Crear ambiente virtual y sincronizar dependencias:**
```bash
# uv automáticamente crea un .venv en el directorio del proyecto
uv sync
```


## Opción 1: Ejecutar con Docker Compose (Recomendado)

### 1. Preparar el archivo CSV
Coloca tu archivo CSV en el directorio del proyecto con el nombre `./data/source/data_jobs.csv`

### 2.a. Levantar los servicios: Base de datos postgres

```bash
docker-compose up -d pgdatabase pgadmin
```



### 2.a. Esperar a que PostgreSQL esté listo (unos 10 segundos)
```bash
docker-compose logs -f pgdatabase
# Espera hasta ver: "database system is ready to accept connections"
```

### 2.c. Levantar los servicios: pgadmin para acceso a base de datos(Sirve para verificar).

```bash
docker-compose up -d pgadmin
```


### 3. Ejecutar la ingesta
```bash
docker-compose up ingest
```



O todo en un solo comando:
```bash
docker-compose up
```

### 4. Verificar los datos

**Opción A - pgAdmin (interfaz web):**
- Abrir http://localhost:8085
- Login: `admin@admin.com` / `root`
- Agregar servidor:
  - Host: `pgdatabase`
  - Port: `5432`
  - User: `root`
  - Password: `root`
  - Database: `data_jobs`

**Opción B - psql (línea de comandos):**
```bash
docker exec -it <container-id-postgres> psql -U root -d data_jobs

#docker exec -it 10fccdab2178 psql -U root -d data_jobs

# Dentro de psql:
\dt                           # Listar tablas
SELECT COUNT(*) FROM data_jobs;  # Contar registros
SELECT * FROM data_jobs LIMIT 5; # Ver primeros 5 registros
```



### Reiniciar desde cero
```bash
docker-compose down -v  # Elimina volúmenes (borra los datos)
docker-compose up -d
```

## Detener servicios

```bash
docker-compose down
```

Para eliminar también los datos:
```bash
docker-compose down -v
```


