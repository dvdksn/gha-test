# SBX Action integration tests

Manually run **SBX Action smoke test** from `main`. Two ephemeral Ubuntu 24.04
x86 runners exercise Claude/Anthropic and Codex/OpenAI independently, using
[dvdksn/sbx-action](https://github.com/dvdksn/sbx-action).

The workflow checks KVM, verifies the pinned SBX installer checksum, starts with
SBX's `deny-all` network preset, authenticates using existing Docker credentials,
and passes only the selected provider key to each agent. It verifies workspace
writes, a blocked unrelated domain, agent execution, and sandbox cleanup.

## Restrictions and ownership

Only manual runs by `dvdksn` on `main` are accepted. There are no PR, issue-comment,
push, or `pull_request_target` triggers. GitHub permissions are read-only and
checkout credentials are not persisted. Actions and SBX downloads are pinned;
the built-in agent kit content is resolved by SBX and is not yet digest-pinned.
Jobs stop after 20 minutes, agent commands after 3 minutes. Claude has a $0.25
per-run budget cap. Set OpenAI project-level spending/rate limits separately;
a timeout is not a monetary cap.

SBX `deny-all` removes baseline allowances; built-in kits can still allow their
own destinations. This is not a strict provider-only allowlist. An unrelated
blocked-domain check provides limited evidence, not a complete egress audit.
Proxy-managed credentials do not eliminate provider spending or disclosure of
workspace data through allowed APIs. The guest environment check accepts only known SBX v0.48 credential sentinels;
this is not a complete audit of every secret exposure mechanism.

The Action owns secret staging, bindings, rejecting host commands by default,
subprocess output handling, and cleanup. The workflow owns trusted triggers,
permissions, runner isolation, policy setup, version pins, provider budgets, and
what happens to results. Test artifacts are data only and expire after one day;
no generated scripts are executed on the runner and nothing is committed or
published by the agents. Keep agent-written files out of later privileged jobs.

Required repository secrets: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`,
`DOCKER_USERNAME`, and `DOCKER_PAT`. Keys are supplied only to the steps needing
them, not at job scope. These tests use a prerelease SBX v0.48.0-rc4 to match the
current environment-file interface.

## Validated runs

[Claude and Codex passed on GitHub-hosted Ubuntu 24.04 x86](https://github.com/dvdksn/gha-test/actions/runs/38264082140).
The test verified provider credential snapshots, guest placeholders with no bound
GitHub credential, an unrelated blocked network destination, workspace changes
made by each agent, and sandbox removal.

**SBX direct kit smoke test** exercises the digest-pinned published
`dvdksn/kit-base` workload without any model provider key. It has the same manual
main-branch/owner restriction as the agent workflow.
