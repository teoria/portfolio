---
title: "AWS + Iceberg, sem Athena e sem Spark"
date: "2026-05-19"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7462301542684061696/"
teaser: "Consulte e crie tabelas Iceberg do catálogo do AWS Glue direto do DuckDB, de qualquer lugar."
excerpt: true
---

Usa tabelas Iceberg na AWS com catálogo no Glue? Vou te mostrar como economizar uma grana agora, anota aí.

Com DuckDB:

1. Instala e carrega as extensões `aws`, `httpfs` e `iceberg`.
2. Carrega a credencial da AWS do ambiente:

```sql
CREATE SECRET (TYPE s3, PROVIDER credential_chain);
```

3. Attacha teu catálogo do Glue:

```sql
ATTACH OR REPLACE '{ACCOUNT_ID}' AS glue_catalog (TYPE iceberg, ENDPOINT_TYPE 'GLUE');
```

4. Agora já pode ler teus Icebergs:

```sql
SELECT count(*) FROM glue_catalog.GLUE_SCHEMA_NAME.ICEBERG_TABLE_NAME;
```

5. E criar também:

```sql
CREATE TABLE glue_catalog.namespace_name.table_name (a INTEGER, b VARCHAR)
WITH ('location' = 's3://path/to/location');
```

Sem Athena e sem Spark. De qualquer lugar, até local, até de uma Lambda ou API REST. :D
