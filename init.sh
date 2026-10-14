#!/usr/bin/env bash
# init.sh — everything needed to work on nodestreaming; exit 0 = ready. Idempotent.
#   ./init.sh            npm ci (reuses node_modules/ when present)
#   ./init.sh --clean    remove node_modules/ first
set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in
    -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --clean) rm -rf node_modules ;;
    '') ;;
    *) echo "Unknown option: $1 (see ./init.sh --help)" >&2; exit 2 ;;
esac
command -v node >/dev/null 2>&1 || { echo "node is required (nvm install 22)" >&2; exit 1; }
echo "== node $(node -v)"
if [ -d node_modules ]; then
    echo "== node_modules present, reusing (./init.sh --clean to rebuild)"
else
    echo "== npm ci"
    npm ci --no-fund --no-audit
fi
echo "ready: ./run.sh (node indes.js on :8000) · ./test.sh"
