---
title: "DuckDB tip: more threads than CPUs"
date: "2026-02-22"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7431141986008690688/"
teaser: "Reading many files into a table? Set threads to two or three times your CPU count."
excerpt: true
---

DuckDB: the most useful tool a data engineer has! Very versatile.

Tip of the day: need to read files and create a table? Set the number of threads to two or three times the number of available CPUs.

Each thread reads one file at a time, which speeds up reading a lot.
