#!/usr/bin/env bash
set -euo pipefail
mkdir -p smoke-results
printf 'direct workspace mount works\n' > smoke-results/workspace.txt
python3 - <<'PY'
import os
placeholders = {'proxy-managed', 'sk-ant-api03-proxy-managed', 'gho_sbxproxymanaged000000000000000000000'}
for name in ('ANTHROPIC_API_KEY', 'OPENAI_API_KEY', 'CODEX_API_KEY'):
    value = os.environ.get(name, '')
    assert not value or value in placeholders, 'non-placeholder provider credential exposed in guest environment'
for name in ('GITHUB_TOKEN', 'GH_TOKEN'):
    value = os.environ.get(name, '')
    assert not value or value in placeholders, 'unexpected non-placeholder GitHub token in guest'
assert os.environ.get('SBX_CRED_GITHUB_MODE', 'none') == 'none', 'unexpected bound GitHub credential'
print('Guest environment has no raw provider key or GitHub token')
PY
status=$(curl --silent --output /dev/null --write-out '%{http_code}' --max-time 15 https://example.com || true)
test "$status" = 403 || { printf 'Unexpected blocked-domain status: %s\n' "$status"; exit 1; }
prompt='This is a CI smoke test. Do not read repository instructions or other files. Run exactly one shell command: printf "agent executed inside sandbox\n" > smoke-results/agent.txt . Then respond with SMOKE_OK. Do not use the network, install tools, or make other changes.'
if command -v claude >/dev/null; then
  timeout 180 claude -p --model haiku --max-turns 2 --max-budget-usd 0.25 \
    --dangerously-skip-permissions "$prompt" > smoke-results/response.txt
else
  timeout 180 codex exec --ephemeral --sandbox workspace-write \
    -o smoke-results/response.txt "$prompt"
fi
test -f smoke-results/agent.txt
