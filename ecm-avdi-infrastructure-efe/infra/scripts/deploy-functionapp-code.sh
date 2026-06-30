#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <resource-group-name> <function-app-name> <zip-package-path>" >&2
  exit 2
fi

resource_group_name="$1"
function_app_name="$2"
zip_package_path="$3"

if [[ ! -f "$zip_package_path" ]]; then
  echo "Function package was not found: $zip_package_path" >&2
  exit 1
fi

az functionapp deployment source config-zip \
  --resource-group "$resource_group_name" \
  --name "$function_app_name" \
  --src "$zip_package_path"
