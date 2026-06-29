---
schema_version: 2
id: practice-opencode-npm-package-name-is-opencode-ai
title: 'OpenCode installs from npm package ''opencode-ai'', not ''opencode'''
kind: practice
tags:
  - devcontainer
  - opencode
  - npm
  - gotcha
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  The npm package for OpenCode is 'opencode-ai'; the installed binary is
  'opencode'. Running npm install -g opencode would install the wrong package.
---
The OpenCode CLI is distributed as the npm package `opencode-ai`, not `opencode`. The feature runs `npm install -g opencode-ai` and the resulting binary is named `opencode`. Running `npm install -g opencode` would install a different, unrelated package.

Verify the install with `command -v opencode` after the container starts.
