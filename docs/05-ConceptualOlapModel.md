📤🗂️📥 Technical assessment- Data engineer  📤🗂️📥

# Job Data Ingestion Pipeline Instrucctions

This project ingests job data from a local CSV file into PostgreSQL using Docker and `uv`, and creates the 3NF schema/ database for PostgreSQL.

**[↑ Up](README.md)** | **[← Previous](04-DatabaseModelsAndDesign.md)** | **[Next →](README.md)**

## 📊 Conceptual OLAP Design (Star Schema)

### Transforming from 3NF to a Star Schema

The 3NF model would be transformed into a **Star Schema** for BI/Analytics:

```
                    ┌─────────────────┐
                    │   dim_company   │
                    ├─────────────────┤
                    │ company_key (SK)│
                    │ company_name    │
                    │ company_size    │
                    │ industry        │
                    └────────┬────────┘
                             │
┌─────────────┐              │              ┌─────────────┐
│  dim_date   │              │              │dim_location │
├─────────────┤              │              ├─────────────┤
│date_key (SK)│              │              │loc_key (SK) │
│ full_date   │              │              │ city        │
│ year        │              │              │ state       │
│ quarter     │              │              │ country     │
│ month       │              │              │ region      │
│ day_of_week │              │              │ is_remote   │
└──────┬──────┘              │              └──────┬──────┘
       │                     │                     │
       │    ┌────────────────┴────────────────┐    │
       │    │                                 │    │
       └────┼─────────────────────────────────┼────┘
            │         fact_job_postings       │
            ├─────────────────────────────────┤
            │ job_key (SK)                    │
            │ company_key (FK)                │
            │ location_key (FK)               │
            │ date_key (FK)                   │
            │ job_title_key (FK)              │
            │ junk_dim_key (FK)               │◄── Junk Dimension
            │ ─────────────────────────       │
            │ salary_year_avg (measure)       │
            │ salary_hour_avg (measure)       │
            │ posting_count (measure = 1)     │
            └─────────────────────────────────┘
                             │
                             │
            ┌────────────────┴────────────────┐
            │     bridge_job_skills           │
            ├─────────────────────────────────┤
            │ job_key (FK)                    │
            │ skill_key (FK)                  │
            └────────────────┬────────────────┘
                             │
                    ┌────────┴────────┐
                    │    dim_skill    │
                    ├─────────────────┤
                    │ skill_key (SK)  │
                    │ skill_name      │
                    │ skill_category  │
                    └─────────────────┘
```

### Fact Table: `fact_jobs_searched`

| Aspect | Decision |
|---------|----------|
| **Grain** | One row = One job posting |
| **Foreign Keys** | company_key, location_key, date_key, job_title_key, junk_dim_key |
| **Measures** | `salary_year_avg`, `salary_hour_avg`, `posting_count` (always 1) 

### Core Dimensions

1. **dim_company**: Company information (enriched with industry, size)
2. **dim_location**: Hierarchical geography (city → state → country → region)
3. **dim_date**: Full calendar for time-based analysis
4. **dim_job_title**: Standardized titles with hierarchy (family → subfamily → title)
5. **dim_skill**: Skills with categorization

### Handling Skills (Bridge Table)

The many-to-many relationship jobs ↔ skills is solved with a **bridge table**:

```sql
-- Analysis: Top 10 most in-demand skills
SELECT 
    s.skill_name,
    COUNT(DISTINCT b.job_key) as job_count
FROM bridge_job_skills b
JOIN dim_skill s ON b.skill_key = s.skill_key
GROUP BY s.skill_name
ORDER BY job_count DESC
LIMIT 10;

### Junk Dimension for Boolean Flags

Boolean fields are consolidated into a **Junk Dimension**:

```sql
CREATE TABLE dim_job_flags (
    junk_key INT PRIMARY KEY,
    is_remote VARCHAR(3),              -- 'Yes' / 'No'
    no_degree_required VARCHAR(3),     -- 'Yes' / 'No'
    has_health_insurance VARCHAR(3)    -- 'Yes' / 'No'
);

-- Populate with all combinations
INSERT INTO dim_job_flags VALUES
(1, 'No',  'No',  'No'),
(2, 'No',  'No',  'Yes'),
(3, 'No',  'Yes', 'No'),
(4, 'No',  'Yes', 'Yes'),
(5, 'Yes', 'No',  'No'),
(6, 'Yes', 'No',  'Yes'),
(7, 'Yes', 'Yes', 'No'),
(8, 'Yes', 'Yes', 'Yes');
```

**Benefits:**:
- Reduces columns in the fact table
- Enables easy filtering: WHERE junk.is_remote = 'Yes'
- Standard approach in dimensional modeling

### Key Dashboard Metrics

| Metric | Formula | Usage |
|---------|---------|-----|
| Total Postings | `COUNT(*)` | Primary KPI |
| Avg Salary | `AVG(salary_year_avg)` | Salary trends |
| Remote % | `SUM(CASE WHEN is_remote='Yes' THEN 1 END) / COUNT(*)` | WFH analysis |
| Skills Demand | `COUNT(*) por skill` | Trending skills |
| Posting Velocity | `COUNT(*) por mes` | Temporal trends |

---

**[↑ Up](README.md)** | **[← Previous](04-DatabaseModelsAndDesign.md)** | **[Next →](README.md)**