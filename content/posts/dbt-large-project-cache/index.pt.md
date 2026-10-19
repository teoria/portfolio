---
title: "dbt + projetos grandes: pule o cache"
date: "2026-03-04"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7434773322497683456/"
teaser: "Mais de 1.000 models e o dbt demora para começar? Desative ou restrinja o cache relacional."
excerpt: true
---

Tem mais de 1.000 models? Essa dica é pra você!

Sabe quando você só precisa rodar alguns models e o dbt demora muito para começar a execução? É o cache!

> "At the beginning of executions, dbt caches metadata about all objects in all schemas where it can materialize resources (such as models). By default, dbt populates the relational cache with information about all schemas related to the project." (documentação do dbt)

Dá para desativar o cache com uma flag e rodar mais rápido.

Use `--no-populate-cache` para não esperar por todos os models:

```bash
dbt run --no-populate-cache -s my_model_name
```

Use `--cache-selected-only` para fazer cache só dos models selecionados:

```bash
dbt run --cache-selected-only -s my_model_name
```
