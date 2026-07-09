#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <env>" >&2
  exit 1
fi

env_name="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
app_dir="$(cd "${script_dir}/.." && pwd)"
repo_root="$(cd "${app_dir}/../../.." && pwd)"

source_env_file="${repo_root}/.vscode/.${env_name}.env"
encoded_env_file="${repo_root}/.vscode/.base64.${env_name}.env"

if [[ ! -f "${source_env_file}" ]]; then
  echo "Missing env file: ${source_env_file}" >&2
  exit 1
fi

printf 'ENVIRONMENT=%s\n' "$(base64 < "${source_env_file}" | tr -d '\n')" > "${encoded_env_file}"

echo "Running Flutter with ${encoded_env_file}"
cd "${app_dir}"
exec flutter run \
  --target lib/main.dart \
  --dart-define-from-file="${encoded_env_file}"
