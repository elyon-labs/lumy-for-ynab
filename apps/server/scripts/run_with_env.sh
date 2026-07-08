#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <env>" >&2
  echo "Supported local envs: local, development" >&2
  exit 1
fi

env_name="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
server_dir="$(cd "${script_dir}/.." && pwd)"

case "${env_name}" in
  local | development)
    export ENVIRONMENT=development
    ;;
  *)
    echo "Unsupported env: ${env_name}" >&2
    echo "The server loads apps/server/.env only when ENVIRONMENT=development." >&2
    exit 1
    ;;
esac

if [[ ! -f "${server_dir}/.env" ]]; then
  echo "Missing env file: ${server_dir}/.env" >&2
  exit 1
fi

echo "Running server with ENVIRONMENT=${ENVIRONMENT}"
echo "Server env file: ${server_dir}/.env"
echo "Port: ${PORT:-8080}"

cd "${server_dir}"
exec dart run bin/server.dart
