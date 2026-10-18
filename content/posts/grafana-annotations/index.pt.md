---
title: "Grafana + Annotations"
date: 2026-08-18
teaser: Cada deploy vira uma marcação no gráfico de monitoramento. Bate o olho e sabe se um deploy recente impactou a infra.
---

Uma coisa muuuito útil que eu não usava: **annotations**.

A cada deploy, a GitHub Action faz um POST na API do Grafana salvando uma anotação no seu gráfico de monitoramento (aquela marcação vertical vermelha). Cada barra vertical é um deploy do seu time!

Bate o olho e sabe na hora se teve um deploy recente que pode ter impactado algo na infra.

Yelken Gonzales, obrigado pelo lab de observabilidade, aprendi muito!
