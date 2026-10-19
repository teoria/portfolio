---
title: "dbt + large projects: skip the cache"
date: "2026-03-04"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7434773322497683456/"
teaser: "More than 1,000 models and dbt takes ages to start? Disable or narrow the relational cache."
excerpt: true
---

Do you have more than 1,000 models? This tip is for you!

You know when you only need to run a few models and dbt takes a long time to start? That's the cache!

> "At the beginning of executions, dbt caches metadata about all objects in all schemas where it can materialize resources (such as models). By default, dbt populates the relational cache with information about all schemas related to the project." (dbt docs)

You can disable caching with a flag to run faster.

Use `--no-populate-cache` to avoid waiting for all models:

```bash
dbt run --no-populate-cache -s my_model_name
```

Use `--cache-selected-only` to cache only the selected models:

```bash
dbt run --cache-selected-only -s my_model_name
```
