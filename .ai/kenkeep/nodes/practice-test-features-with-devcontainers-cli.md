---
schema_version: 2
id: practice-test-features-with-devcontainers-cli
title: Test features locally with 'devcontainer features test'
kind: practice
tags:
  - devcontainer
  - testing
  - local-dev
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  Use @devcontainers/cli for local feature testing; 'devcontainer features test
  -f <feature> .' runs one feature's scenarios, omitting -f runs all.
---
Install `@devcontainers/cli` globally (`npm install -g @devcontainers/cli`) to run feature tests locally. The test command reads scenario definitions from `test/<feature>/scenarios.json`.

```bash
# All features, all scenarios
devcontainer features test .

# One feature only
devcontainer features test -f claude .

# Specific base image
devcontainer features test -f t3 -i node:24 .
```

Tests are defined under `test/<feature>/test.sh` (default smoke test) and `test/<feature>/scenarios.json` (named scenario matrix). Multi-feature integration tests live in `test/_global/scenarios.json`.
