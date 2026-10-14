#!/usr/bin/env bash
# test.sh — every check in one place; exit 0 = green. `./run.sh test` runs this script.
# There is no test suite (package.json's "test" is npm's placeholder), so this is
# deps, no tracked .env, shell, and node --check over every .js file.
set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;; esac
[ -d node_modules ] || { echo "node_modules missing: run ./init.sh first" >&2; exit 1; }

echo "== deps match package-lock.json"
npm ls --depth=0 >/dev/null

echo "== no tracked .env"
tracked="$(git ls-files | grep -E '(^|/)\.env(\..+)?$' | grep -vE '\.env\.(example|template)$' || true)"
[ -z "$tracked" ] || { echo "tracked env files:"; echo "$tracked"; exit 1; }

echo "== shell"
for f in ./*.sh; do bash -n "$f"; /bin/bash -n "$f"; done
if command -v shellcheck >/dev/null 2>&1; then shellcheck -S warning ./*.sh; else echo "   shellcheck not installed (brew install shellcheck); syntax-checked only"; fi

echo "== javascript syntax (node --check)"
n=0
for f in ./*.js; do [ -f "$f" ] || continue; node --check "$f"; n=$((n + 1)); done
echo "   $n file(s) checked"
echo "== all green"
