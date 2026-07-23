---
description: Verify a gh-aw agent running in a Docker Sandbox
on:
  workflow_dispatch:
permissions:
  contents: read
engine: codex
model: gpt-5.4
runs-on: ubuntu-latest
timeout-minutes: 20
network:
  allowed:
    - defaults
sandbox:
  agent:
    id: awf
    runtime: docker-sbx
    sudo: true
tools:
  github:
    mode: remote
    toolsets:
      - repos
  bash:
    - "uname -a"
    - "cat /etc/os-release"
    - "docker version"
---

# Docker Sandbox smoke test

Run each of the following commands and report the output:

1. `uname -a`
2. `cat /etc/os-release`
3. `docker version`

Explain which results show that you are running inside an isolated Linux
environment with its own Docker daemon. Don't modify files or create GitHub
issues, pull requests, or comments.
