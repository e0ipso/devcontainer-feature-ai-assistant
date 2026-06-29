---
schema_version: 2
id: practice-features-auto-update-via-postupdate-on-poststart
title: All features auto-update the CLI at every postStart by default
kind: practice
tags:
  - devcontainer
  - feature
  - update
  - poststart
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  updateOnPostStart defaults to true for all features; the feature re-runs the
  installer or npm install at each container start to pull the latest version.
---
Every feature exposes an `updateOnPostStart` boolean option (default `true`). When enabled, the feature's `postStart` script re-runs the installer (for claude and cursor) or runs `npm install -g <package>` (for codex, copilot, opencode, and t3) to update the CLI to the latest available version.

Set `"updateOnPostStart": false` to pin the version installed at image build time and avoid network traffic on container start.
