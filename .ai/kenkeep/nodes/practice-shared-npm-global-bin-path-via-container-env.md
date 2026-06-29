---
schema_version: 2
id: practice-shared-npm-global-bin-path-via-container-env
title: All features share /usr/local/share/npm-global/bin on PATH via containerEnv
kind: practice
tags:
  - devcontainer
  - path
  - npm
  - feature
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  Every feature prepends /usr/local/share/npm-global/bin to PATH through feature
  containerEnv; no extra remoteEnv wiring is needed when combining features.
---
All six features install their binaries to `/usr/local/share/npm-global/bin` and each feature independently prepends that path to `PATH` via `containerEnv`. Because the same path segment is added by every feature, combining multiple features does not require any additional `remoteEnv` wiring.

This shared prefix is why `claude`, `codex`, `copilot`, `agent`, `opencode`, and `t3` are all available to the non-root remote user without further shell configuration.
