---
title: "Dica de DuckDB: mais threads que CPUs"
date: "2026-02-22"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7431141986008690688/"
teaser: "Lendo muitos arquivos para uma tabela? Use o dobro ou o triplo de threads em relação às CPUs."
excerpt: true
---

DuckDB: a ferramenta mais útil de um engenheiro de dados! Muito versátil.

Dica do dia: precisa ler arquivos e criar uma tabela? Use a quantidade de threads o dobro ou o triplo da quantidade de CPUs disponíveis.

Cada thread vai ler um arquivo por vez, e isso acelera demais o processo de leitura.
