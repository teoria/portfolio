---
title: "Real-time + Iceberg"
date: 2026-09-05
teaser: Streaming ingestion that merges into Iceberg tables creates small files. Without maintenance, everything gets slower and more expensive every day.
---

Whenever stream ingestion merges into Iceberg tables, it writes a huge number of small files.

The number of data and metadata files grows very quickly, and simple queries have to read a looot of files, which makes everything slower and more expensive every day!

Have a maintenance process for compaction and cleanup, to avoid table degradation and an explosion of S3 GET costs.

This tip can save you thousands of dollars… literally. :D

If you use dbt and Iceberg, the [dbt-iceberg-utils](https://github.com/teoria/dbt-iceberg-utils) package can help you find the tables that need maintenance.
