---
title: "Data Contracts + IA"
date: 2026-10-09
teaser: Usando GitHub Action, Airflow, dbt e um LLM para avisar cada time quando uma mudança de schema no seu repo vai quebrar o data lake no downstream.
---

**Contexto:** tenho pipelines que consomem databases de múltiplos projetos e atualizam o data lake (a maioria diariamente, mas também por hora e até em tempo real).

**Problema:** cada projeto pertence a um time diferente, que tem autonomia para mudar qualquer coisa. Mudanças de schema ou de valores esperados podem causar falha na pipeline e nas aplicações downstream.

**Hipótese:** será que consigo monitorar essas mudanças e alertar quando o change impactará algum downstream?

**Sim!**

**Solução:** para capturar as mudanças nos repos dos projetos, usei uma GitHub Action que verifica se houve mudança na pasta de migrations e dispara uma DAG do Airflow. A task do Airflow roda uma imagem no Fargate que clona o projeto dbt do lake e usa o Sonnet 5.5 para verificar se o change do commit pode quebrar um contrato ou impactar algum teste de data quality.

O resultado vai para um canal do Slack, onde todos os times ficam cientes do impacto que aquele commit pode causar na próxima pipeline. Pequenas evoluções de schema (novas colunas) já geram um PR atualizando automaticamente os contratos e as views do dbt.

**Próxima versão:**

- Self-healing: fix automático da pipeline e dos downstreams impactados.
- Shift left: bloqueio do merge nos projetos quando o change impactar produtos importantes no downstream.

Já usa algum AIOps na sua operação?
