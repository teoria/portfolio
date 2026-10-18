---
title: "Tempo real + Iceberg"
date: 2026-09-05
teaser: Ingestão por streaming com merge em tabelas Iceberg gera small files. Sem manutenção, tudo fica mais lento e mais caro a cada dia.
---

Sempre que tiver ingestão de stream fazendo merge em tabelas Iceberg, existirá uma quantidade gigante de escrita de small files.

A quantidade de arquivos de dados e de metadados escala muito rapidamente, e queries simples precisam ler muuuitos arquivos, o que deixa tudo mais lento e mais caro a cada dia!

Tenha um processo de manutenção para otimização e limpeza, para evitar a degradação da sua tabela e a explosão do custo de GET no S3.

Essa dica pode te economizar milhares de dólares… literalmente. :D

Se usa dbt e Iceberg, o package [dbt-iceberg-utils](https://github.com/teoria/dbt-iceberg-utils) pode te ajudar a encontrar as tabelas que precisam de manutenção.
