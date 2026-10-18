---
title: "Data Contracts + AI"
date: 2026-10-09
teaser: Using a GitHub Action, Airflow, dbt and an LLM to warn every team when a schema change in their repo will break the data lake downstream.
---

**Context:** I have pipelines that pull from databases across multiple projects and update the data lake (mostly daily, but also hourly and even real-time).

**Problem:** each project belongs to a different team with full autonomy to change anything. Schema changes or unexpected values can break the pipeline and downstream applications.

**Hypothesis:** can I monitor these changes and alert when a change will impact something downstream?

**Yes!**

**Solution:** to capture changes in the project repos, I used a GitHub Action that checks whether the migrations folder changed and triggers an Airflow DAG. The Airflow task runs an image on Fargate that clones the data lake's dbt project and uses Sonnet 5.5 to check whether the commit could break a contract or affect any data quality test.

The result goes to a Slack channel, so every team knows what impact that commit could have on the next pipeline run. Small schema changes (new columns) automatically open a PR that updates the contracts and dbt views.

**Next version:**

- Self-healing: automatic fixes for the pipeline and any impacted downstreams.
- Shift left: block merges in source projects when a change would impact critical downstream products.

Are you already using AIOps in your operations?
