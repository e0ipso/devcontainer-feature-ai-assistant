---
schema_version: 2
id: map-t3-feature-is-a-meta-harness
title: t3 feature is a meta-harness that orchestrates other AI providers
kind: map
tags:
  - devcontainer
  - t3
  - meta-harness
  - providers
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  The t3 devcontainer feature installs T3 Code, a meta-harness that can route
  requests to Claude agent, Codex, Cursor, Grok, and OpenCode as providers.
---
The `t3` feature installs [T3 Code](https://github.com/pingdotgg/t3code), a meta-harness that can route code-assistant requests to multiple underlying AI providers: Claude agent, Codex, Cursor, Grok, and OpenCode. Each provider is independently toggled and configured via feature options.

Options are organized into groups: general settings (`enableAssistantStreaming`, `automaticGitFetchInterval`, `defaultThreadEnvMode`), model selection (`textGenerationModelSelectionInstanceId`, `textGenerationModelSelectionModel`), observability (OTLP endpoints), and per-provider flags (`providersCodex*`, `providersClaudeAgent*`, `providersCursor*`, `providersGrok*`, `providersOpenCode*`).

By default, Codex, Claude agent, Grok, and OpenCode are enabled; Cursor is disabled. Set `textGenerationModelSelectionInstanceId` and `textGenerationModelSelectionModel` to choose the active model.
