---
title: "dbt docs inside Airflow with Cosmos"
date: "2026-02-06"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7425402578063998977/"
teaser: "Running dbt models in Airflow with Cosmos? One setting serves the generated dbt docs inside Airflow."
excerpt: true
---

Do you use Cosmos to run your dbt models in Airflow?

Did you know you can open the generated dbt docs inside Airflow? I've never seen anyone show this, I only just found out.

Just set the path:

```bash
AIRFLOW__COSMOS__DBT_DOCS_DIR="/usr/local/airflow/dags/my_dbt_project/target"
```
