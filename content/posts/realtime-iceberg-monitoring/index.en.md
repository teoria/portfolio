---
title: "Real-time pipeline + Iceberg + monitoring"
date: 2026-09-14
teaser: How small files in streaming Iceberg tables blew up an S3 bill, and the monitoring and self-healing that cut it by 64%.
---

Real-time data arriving via streaming and automatically materializing as lakehouse tables is the dream of many stakeholders.

Kafka with Kafka Connect, AWS Firehose, or Airbyte syncing data into Iceberg tables brings the power of real-time pipelines to your operation. It also brings an old acquaintance of every data engineering team: **small files**.

Combined with Iceberg metadata scans, they make your S3 bill explode. Not because of volume, but because of the number of GET requests your engine issues per query.

I recently worked on a cost optimization for a real-time pipeline, and the hardest part was pinpointing where the problem came from. Monitoring S3 with Storage Lens was critical to prioritize what to optimize first.

I rewrote the small files into larger ones, cleaned up deleted records, fixed partitions and metadata, and used my dbt library iceberg_utils to monitor table degradation. I built a weekly self-healing flow based on the data iceberg_utils collects daily.

**Results:**

- Queries 50%+ faster
- Storage: 90%+ reduction in the streaming bucket (TB to GB)
- Cost: 64% reduction in S3 costs (storage + GET)

We saved the equivalent of a two-bedroom apartment in my city per year. :D
