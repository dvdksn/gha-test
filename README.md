# SBX Action examples and tests

Manual workflows for [dvdksn/sbx-action](https://github.com/dvdksn/sbx-action),
on GitHub-hosted Ubuntu 24.04 runners.

Start with [the agent smoke workflow](.github/workflows/sbx-smoke.yml): checkout,
run Claude or Codex to summarize the repository, and upload the summary. The
Action installs SBX and authenticates Docker using repository secrets.

Required secrets: `DOCKER_USERNAME`, `DOCKER_PAT`, `ANTHROPIC_API_KEY`, and
`OPENAI_API_KEY`.

Additional integration tests cover credential boundaries, direct versus clone
workspaces, cleanup, and a custom kit. Boundary assertions live in `tests/`.
The custom-kit tests configure the runner's allowed kit sources after a first
Action invocation installs and authenticates SBX.

Workflows accept manual runs by `dvdksn` on `main`, use read-only GitHub
permissions, and disable checkout credential persistence. Use trusted kits and
ephemeral runners. Provider credentials still permit billable API use; configure
provider spending limits. Generated artifacts are for inspection.
