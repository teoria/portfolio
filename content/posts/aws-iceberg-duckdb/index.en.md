---
title: "AWS + Iceberg, without Athena or Spark"
date: "2026-05-19"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7462301542684061696/"
teaser: "Query and create Iceberg tables in the AWS Glue catalog straight from DuckDB, from anywhere."
excerpt: true
---

Using Iceberg tables on AWS with the Glue catalog? Here's how to save some money right now.

With DuckDB:

1. Install and load the `aws`, `httpfs` and `iceberg` extensions.
2. Load the AWS credentials from the environment:

```sql
CREATE SECRET (TYPE s3, PROVIDER credential_chain);
```

3. Attach your Glue catalog:

```sql
ATTACH OR REPLACE '{ACCOUNT_ID}' AS glue_catalog (TYPE iceberg, ENDPOINT_TYPE 'GLUE');
```

4. Read your Iceberg tables:

```sql
SELECT count(*) FROM glue_catalog.GLUE_SCHEMA_NAME.ICEBERG_TABLE_NAME;
```

5. And create them too:

```sql
CREATE TABLE glue_catalog.namespace_name.table_name (a INTEGER, b VARCHAR)
WITH ('location' = 's3://path/to/location');
```

No Athena, no Spark. From anywhere, even locally, even from a Lambda or a REST API. :D
