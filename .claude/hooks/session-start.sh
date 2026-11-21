#!/usr/bin/env bash
# Prepara el proyecto al iniciar una sesión de Claude Code en la nube.
# En local no hace nada: ahí el entorno lo maneja el desarrollador.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [ ! -d vendor ]; then
  composer install --no-interaction --prefer-dist --no-progress >&2
fi

# .env mínimo para correr tests con SQLite en memoria.
if [ ! -f .env ]; then
  cp .env.example .env
  sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=sqlite/' .env
  sed -i 's/^DB_DATABASE=.*/DB_DATABASE=:memory:/' .env
  php artisan key:generate --ansi >&2
  php artisan jwt:secret --force >&2 || true
  grep -q '^KEY_ENCRYPT=' .env || echo 'KEY_ENCRYPT=local-dev-key' >> .env
fi

if [ ! -f .env.testing ]; then
  cp .env .env.testing
fi
