#!/usr/bin/env bash
# Formatea con Laravel Pint cada archivo PHP que Claude edita.
set -uo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | php -r '$d=json_decode(stream_get_contents(STDIN),true); echo $d["tool_input"]["file_path"] ?? "";')"

case "$file" in
  *.php) ;;
  *) exit 0 ;;
esac

pint="$CLAUDE_PROJECT_DIR/vendor/bin/pint"
[ -x "$pint" ] || exit 0
[ -f "$file" ] || exit 0

"$pint" --quiet "$file" >/dev/null 2>&1 || true
exit 0
