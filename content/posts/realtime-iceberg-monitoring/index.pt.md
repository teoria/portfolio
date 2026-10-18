---
title: "Pipeline em tempo real + Iceberg + monitoramento"
date: 2026-09-14
teaser: Como small files em tabelas Iceberg de streaming explodiram a conta do S3, e o monitoramento e self-healing que cortaram 64% do custo.
---

Dados em tempo real chegando por streaming e materializando automaticamente como tabelas no lakehouse é o sonho de muitos stakeholders!

Kafka com Kafka Connect, AWS Firehose ou um Airbyte sincronizando dados com tabelas Iceberg trazem o poder de pipelines em tempo real para sua operação, mas também trazem um velho conhecido do time de engenharia de dados: **small files**!

Combinados com o scan de metadados das tabelas Iceberg, eles fazem o custo do S3 explodir. Não por conta do volume, mas por conta da quantidade de GETs que sua engine fará para cada consulta.

Recentemente atuei numa otimização de custo em uma pipeline de tempo real e percebi que o mais complicado é identificar de onde vem o problema. Monitorar o S3 com o Storage Lens foi importantíssimo para priorizar o que deveria ser otimizado primeiro.

Reescrevi os small files em arquivos maiores, limpei os registros deletados, arrumei partições e metadados, e usei minha lib dbt iceberg_utils para monitorar a degradação das tabelas. Criei um fluxo de self-healing semanal a partir dos dados coletados diariamente pelo iceberg_utils.

**Resultado:**

- Queries 50%+ mais rápidas
- Storage: redução de 90%+ no bucket de streaming (TB → GB)
- Custo: 64% de redução nos custos de S3 (storage + GET)

Economizamos o equivalente a um apartamento de 2 quartos em Recife por ano! :D
