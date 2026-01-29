FROM python:3.13-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code
ENV PATH="/code/.venv/bin:$PATH"

# Copiar archivos de configuración
COPY pyproject.toml .python-version ./

# Sincronizar dependencias
RUN uv sync

# Copiar script de ingesta
COPY ingest_data.py .

# Copiar archivo CSV (este se montará o copiará desde el host)
# COPY /data/source/data_jobs.csv .

ENTRYPOINT ["uv", "run", "python", "ingest_data.py"]
