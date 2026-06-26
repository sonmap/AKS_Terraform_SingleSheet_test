#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CSV_FILE="${1:-${ROOT_DIR}/design/AKS_Terraform_Design.csv}"
OUT_FILE="${2:-${ROOT_DIR}/env/dev.generated.tfvars}"
ENVIRONMENT="${3:-dev}"

python3 "${ROOT_DIR}/tools/excel_to_tfvars.py" "${CSV_FILE}" "${OUT_FILE}" "${ENVIRONMENT}"

echo "Generated ${OUT_FILE}"
