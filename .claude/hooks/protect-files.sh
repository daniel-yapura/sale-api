#!/usr/bin/env bash
# Bloquea ediciones a archivos sensibles o que no se deben tocar a mano.
# Exit 2 = se bloquea la herramienta y el mensaje de stderr vuelve a Claude.
set -euo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | php -r '$d=json_decode(stream_get_contents(STDIN),true); echo $d["tool_input"]["file_path"] ?? "";')"
[ -z "$file" ] && exit 0

rel="${file#"$CLAUDE_PROJECT_DIR"/}"
base="$(basename "$file")"

case "$base" in
  .env.example) exit 0 ;;
  .env|.env.*)
    echo "Bloqueado: $rel tiene secretos. Editá .env.example o pedile al usuario que lo cambie." >&2
    exit 2 ;;
  composer.lock|package-lock.json)
    echo "Bloqueado: $rel se genera con composer/npm. Usá el comando correspondiente." >&2
    exit 2 ;;
esac

case "$rel" in
  vendor/*|node_modules/*|storage/framework/*|bootstrap/cache/*)
    echo "Bloqueado: $rel es generado o de terceros." >&2
    exit 2 ;;
esac

# Migraciones ya versionadas en git: crear una nueva en lugar de editarla.
if [[ "$rel" == database/migrations/*.php ]] && [ -f "$file" ] \
   && git -C "$CLAUDE_PROJECT_DIR" ls-files --error-unmatch "$rel" >/dev/null 2>&1; then
  echo "Bloqueado: $rel ya está en git. Creá una migración nueva con 'php artisan make:migration'." >&2
  exit 2
fi

exit 0
