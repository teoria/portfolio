---
title: "Time series + LLM"
date: 2026-10-13
linkedin: https://www.linkedin.com/feed/update/urn:li:activity:7515806146931273728/
teaser: I tested Chronos-2, which forecasts time series by treating quantized values as tokens for a language model.
---

I recently came across new time series forecasting techniques that use language models. Very interesting! Some beat classical models and even ensembles!

Yesterday I tested Chronos-2 (available on Hugging Face). The idea is to quantize the historical series, run it through a tokenizer, and use the language model's output probabilities to predict the next token. That token is converted back into a number and rescaled to the input's scale.

**In short:** original series → normalized and quantized series → tokenized values → next-token prediction → converted back to the original series' value.

If you work with time series, it's worth testing and comparing against classical models.
