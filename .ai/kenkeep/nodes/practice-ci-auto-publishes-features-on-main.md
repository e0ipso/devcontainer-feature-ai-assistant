---
schema_version: 2
id: practice-ci-auto-publishes-features-on-main
title: CI auto-publishes features to GHCR on every main push
kind: practice
tags:
  - devcontainer
  - ci
  - publish
  - ghcr
  - versioning
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  The CI workflow publishes all features as OCI images to GHCR on push to main;
  feature version comes from devcontainer-feature.json; consumers pin to :1
  major.
---
The `.github/workflows/ci.yaml` workflow runs on every push to `main` and publishes each `src/<feature>/` directory as an OCI image to `ghcr.io/<owner>/devcontainer-feature-ai-assistant/<feature>`. The image version is read from `"version"` in the feature's `devcontainer-feature.json`.

Consumers should pin to the major version tag (`:1`) to receive non-breaking updates automatically. Bump the version in `devcontainer-feature.json` before merging to publish a new semver tag.

The workflow also attempts to set each GHCR package visibility to public and verifies that anonymous pulls succeed. If the API cannot set visibility, open the package in GitHub Packages settings and set it manually.
