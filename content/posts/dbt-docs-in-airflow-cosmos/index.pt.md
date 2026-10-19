---
title: "Docs do dbt dentro do Airflow com Cosmos"
date: "2026-02-06"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7425402578063998977/"
teaser: "Roda models do dbt no Airflow com Cosmos? Uma configuração abre a documentação gerada do dbt dentro do Airflow."
excerpt: true
---

Você usa Cosmos para rodar seus models do dbt no Airflow?

Tá ligado que dá pra abrir a doc gerada dentro do Airflow? Nunca vi ninguém mostrando isso, só descobri agora.

Só setar o path:

```bash
AIRFLOW__COSMOS__DBT_DOCS_DIR="/usr/local/airflow/dags/my_dbt_project/target"
```
