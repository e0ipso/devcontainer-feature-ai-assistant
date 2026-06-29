---
schema_version: 2
id: practice-copilot-auth-via-gh-cli
title: Copilot feature authenticates via GitHub CLI; has no credential seeding
kind: practice
tags:
  - devcontainer
  - copilot
  - auth
  - gotcha
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  The copilot feature has no seedConfig or seedCredentials options; authenticate
  with gh auth login inside the container or bind-mount ~/.config/gh from the
  host.
---
Unlike the claude, codex, cursor, and opencode features, the `copilot` feature has no `seedConfig` or `seedCredentials` option. Authentication is entirely via the GitHub CLI: run `gh auth login` inside the container, or bind-mount the host's `~/.config/gh` directory to reuse existing credentials.

The feature declares `installsAfter: github-cli`, signaling that the GitHub CLI should be installed first if it is not already present in the base image.
