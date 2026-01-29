#!/usr/bin/env python
# coding: utf-8

import click
import pandas as pd
from sqlalchemy import create_engine
from tqdm.auto import tqdm
import os

dtype = {
    "job_title_short": "string",
    "job_title": "string",
    "job_location": "string",
    "job_via": "string",
    "job_schedule_type": "string",
    "job_work_from_home": "bool",
    "search_location": "string",
    "job_no_degree_mention": "bool",
    "job_health_insurance": "bool",
    "job_country": "string",
    "salary_rate": "string",
    "salary_year_avg": "float64",
    "salary_hour_avg": "float64",
    "company_name": "string",
    "job_skills": "string",
    "job_type_skills": "string"
}

parse_dates = [
    "job_posted_date"
]


@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL user')
@click.option('--pg-pass', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default=5432, type=int, help='PostgreSQL port')
@click.option('--pg-db', default='data_jobs', help='PostgreSQL database name')
@click.option('--csv-file', default='./data/source/data_jobs.csv', help='Path to CSV file')
@click.option('--target-table', default='data_jobs', help='Target table name')
@click.option('--chunksize', default=100000, type=int, help='Chunk size for reading CSV')
def run(pg_user, pg_pass, pg_host, pg_port, pg_db, csv_file, target_table, chunksize):
    """Ingest job data from local CSV into PostgreSQL database."""
    
    if not os.path.exists(csv_file):
        click.echo(f"Error: CSV file '{csv_file}' not found!")
        return
    
    click.echo(f"Reading data from: {csv_file}")
    
    engine = create_engine(f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}')

    df_iter = pd.read_csv(
        csv_file,
        dtype=dtype,
        parse_dates=parse_dates,
        iterator=True,
        chunksize=chunksize,
    )

    first = True

    for df_chunk in tqdm(df_iter):
        if first:
            df_chunk.head(0).to_sql(
                name=target_table,
                con=engine,
                if_exists='replace'
            )
            first = False

        df_chunk.to_sql(
            name=target_table,
            con=engine,
            if_exists='append'
        )
    
    click.echo(f"Data successfully ingested into table '{target_table}'!")

if __name__ == '__main__':
    run()
