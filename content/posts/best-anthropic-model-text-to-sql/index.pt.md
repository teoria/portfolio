---
title: "Qual o melhor modelo da Anthropic para text-to-SQL?"
date: "2026-05-20"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7462947792240472065/"
teaser: "300 perguntas da WikiSQL com Opus, Sonnet e Haiku: acerto versus custo."
excerpt: true
---

Qual o melhor modelo da Anthropic para text-to-SQL? Usei 300 perguntas do benchmark WikiSQL.

- **Melhor resultado:** o Opus 4.7 respondeu corretamente 82,4%, e 73% foram exatamente a query esperada.
- **Custo-benefício Opus:** o Opus 4.6 e o 4.7 tiveram 82,4% e 82%, custando US$ 4,73 e US$ 3,31. O Opus 4.6 teve desempenho equivalente sendo 30% mais barato (menos tokens).
- **Sonnet:** o Sonnet 4.6 fez 76% contra 67,3% do Sonnet 4.5, com o mesmo custo (US$ 0,66). Quase 10 pontos percentuais a mais pelo mesmo preço.
- **Sonnet 4.5 vs Haiku 4.5:** o Haiku 4.5 também fez 67,3%, custando US$ 0,22. Mesmo desempenho do Sonnet 4.5 e 66% mais barato.

Querem saber o desempenho dos open source?
