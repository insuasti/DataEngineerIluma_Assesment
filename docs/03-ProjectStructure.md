📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.

**[↑ Up](README.md)** | **[← Previous](02-Checklist.md)** | **[Next →](04-DatabaseModelsAndDesign.md)**

#" 🗂️ Project Structure and Commit Conventions


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


## 🔖 Commit Conventions

Este es una convención que utiliza prefijos específicos en los mensajes de commit para indicar el tipo de cambio que se realizó en el código.

**Recomendaciones:**

* Usar el mismo idioma dentro del mismo repositorio para mayor coherencia y claridad, se recomienda inglés por universalidad.

* Escribir los commits iniciando con verbos en presente simple, es decir, crear, actualizar, administrar o *create, update, manage* en inglés.

* Cuando se va a realizar un cambio que podría ser muy grande o "rompedor", usar el formato **BREAKING CHANGE** en el que si se va a realizar un gran cambio, se deja un ! luego del prefijo y el alcance/contexto, ejemplo:  	```
fix(lambda)!: Change of the orchestration to step functions.	```
-
<table>
  <tr>
    <th colspan="4" align="center">🚀CONVENTIONAL COMMIT🚀</th>
  </tr>
  
  <tr>
    <th align="center"><strong>Tipo (prefijo)</strong></th>
    <th align="center"><strong>Contexto</strong></th>
    <th align="center"><strong>Descripción</strong></th>
    <th align="center"><strong>Ejemplo</strong></th>
  </tr>
  <tr>
    <td align="center">feat</td>
    <td align="center">classes</td>
    <td>Añadir clase para limpieza de datos</td>
    <td><code>feat (classes): Add functions to clean data</code></td>
  </tr>
  <tr>
    <td align="center">fix</td>
    <td align="center">data</td>
    <td>Corregir repositorio de datos actualizado</td>
    <td><code>fix (data): Fix the clients data repository</code></td>
  </tr>
  <tr>
    <td align="center">docs</td>
    <td align="center">docs</td>
    <td>Crear la documentación inicial del proyecto</td>
    <td><code>docs (docs): Create README.md file of the project</code></td>
  </tr>
  <tr>
    <td align="center">chore</td>
    <td align="center">Models</td>
    <td>Adicionar nueva variable “edad” al modelo</td>
    <td><code>chore (models): Add new variable age, to the model</code></td>
  </tr>
  <tr>
    <td align="center">test</td>
    <td align="center">notebooks</td>
    <td>Pruebas sobre el resultado del notebook generado</td>
    <td><code>test (notebooks): Create unit test of a notebook component</code></td>
  </tr>
  <tr>
    <td colspan="4"  align="center"><strong>Source:</strong> <a href="https://www.conventionalcommits.org/en/v1.0.0/">https://www.conventionalcommits.org/en/v1.0.0/</a></td>    
  </tr>
  <tr>    
    <td colspan="4" align="center"><strong>Created by:</strong> Daniel Insuasti</td>
  </tr>
</table>

**[↑ Up](README.md)** | **[← Previous](02-Checklist.md)** | **[Next →](04-DatabaseModelsAndDesign.md)**


