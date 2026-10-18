---
title: "Grafana + Annotations"
date: 2026-08-18
teaser: Every deploy becomes a marker on the monitoring chart. One glance tells you whether a recent deploy affected the infrastructure.
---

Something veeery useful that I wasn't using: **annotations**.

On every deploy, the GitHub Action POSTs to the Grafana API, saving an annotation on your monitoring chart (that red vertical marker). Each vertical bar is a deploy from your team!

One glance and you know right away whether a recent deploy may have affected something in the infrastructure.

Yelken Gonzales, thanks for the observability lab, I learned a lot!
