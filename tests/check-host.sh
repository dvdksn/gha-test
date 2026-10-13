#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
from pathlib import Path
assert Path('smoke-results/workspace.txt').read_text() == 'direct workspace mount works\n'
assert Path('smoke-results/agent.txt').read_text() == 'agent executed inside sandbox\n'
assert 'SMOKE_OK' in Path('smoke-results/response.txt').read_text()
print('Agent execution and writable host workspace verified')
PY
sbx ls --format json > "$RUNNER_TEMP/sandbox-list.json"
python3 - <<'PY'
import json, os
from pathlib import Path
items = json.loads((Path(os.environ['RUNNER_TEMP']) / 'sandbox-list.json').read_text())
assert not any(item.get('name') == os.environ['SANDBOX_NAME'] for item in items)
print('Sandbox cleanup verified')
PY
