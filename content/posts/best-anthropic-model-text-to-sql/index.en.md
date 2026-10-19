---
title: "Which Anthropic model is best for text-to-SQL?"
date: "2026-05-20"
linkedin: "https://www.linkedin.com/feed/update/urn:li:activity:7462947792240472065/"
teaser: "300 WikiSQL questions across Opus, Sonnet and Haiku: accuracy versus cost."
excerpt: true
---

Which Anthropic model is best for text-to-SQL? I used 300 questions from the WikiSQL benchmark.

- **Best result:** Opus 4.7 answered 82.4% correctly, and 73% matched the expected query exactly.
- **Opus cost-benefit:** Opus 4.6 and 4.7 scored 82.4% and 82%, costing $4.73 and $3.31. Opus 4.6 performed the same while being 30% cheaper (fewer tokens).
- **Sonnet:** Sonnet 4.6 hit 76% against 67.3% for Sonnet 4.5, at the same cost ($0.66). Almost 10 points better for the same price.
- **Sonnet 4.5 vs Haiku 4.5:** Haiku 4.5 also scored 67.3%, at $0.22. Same performance as Sonnet 4.5 and 66% cheaper.

Want to see how the open source models did?
