#!/usr/bin/env bash
# run.sh — the project's entry points. Run ./init.sh once first.
#   ./run.sh [start]     Express video-streaming server, node indes.js on http://localhost:8000
#   ./run.sh test        every check (./test.sh)
set -euo pipefail
cd "$(dirname "$0")"
cmd="${1:-start}"
[ $# -gt 0 ] && shift
case "$cmd" in
    -h|--help|help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    test) exec ./test.sh "$@" ;;
    start) ;;
    *) echo "Unknown command: $cmd (see ./run.sh --help)" >&2; exit 2 ;;
esac
[ -d node_modules ] || { echo "node_modules missing: run ./init.sh first" >&2; exit 1; }
[ -f indes.js ] || { echo "indes.js not found (the server file; not tracked in git yet)" >&2; exit 1; }
exec node indes.js
