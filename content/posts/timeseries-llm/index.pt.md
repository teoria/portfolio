---
title: "Séries temporais + LLM"
date: 2026-10-13
linkedin: https://www.linkedin.com/feed/update/urn:li:activity:7515806146931273728/
teaser: Testei o Chronos-2, que prevê séries temporais tratando valores quantizados como tokens de um modelo de linguagem.
---

Conheci recentemente novas técnicas de previsão de séries temporais usando modelos de linguagem. Muito interessante! Alguns batendo modelos clássicos e até ensembles!

Ontem testei o Chronos-2 (disponível no Hugging Face). A ideia é quantizar a série histórica, passá-la por um tokenizador e usar a probabilidade de saída do modelo de linguagem para prever o próximo token. Esse token é convertido de volta para número e escalado para a mesma escala da entrada.

**Resumindo:** série original → série normalizada e quantizada → tokenização dos valores → predição do próximo token → conversão de volta para o valor da série original.

Se você trabalha com séries temporais, vale a pena testar e comparar com os modelos clássicos.
