#!/usr/bin/env bash
# Bitbucket Pipe entrypoint: maps the pipe variables and the Bitbucket defaults onto the shared marker script.
set -uo pipefail

export SENTINEL_CLIENT_ID="${SENTINEL_CLIENT_ID:-}"
export SENTINEL_CLIENT_SECRET="${SENTINEL_CLIENT_SECRET:-}"
export VERSION="${VERSION:-${BITBUCKET_COMMIT:-}}"
export COMMIT_SHA="${COMMIT_SHA:-${BITBUCKET_COMMIT:-}}"
export DEPLOY_URL="${URL:-${BITBUCKET_REPO_FULL_NAME:+https://bitbucket.org/${BITBUCKET_REPO_FULL_NAME}/pipelines/results/${BITBUCKET_BUILD_NUMBER:-}}}"
# A rerun of the step is the same deployment; the run id only admits [A-Za-z0-9._:-], so the braces of the UUID go.
pipeline_uuid="${BITBUCKET_PIPELINE_UUID:-}"
export RUN_ID="${RUN_ID:-${pipeline_uuid//[\{\}]/}}"
export ACCOUNT_ID="${ACCOUNT_ID:-}" MONITORING_SERVICE_ID="${MONITORING_SERVICE_ID:-}"
export STARTED_AT="${STARTED_AT:-}" FINISHED_AT="${FINISHED_AT:-}"
export API_URL="${API_URL:-https://api.aaa-sentinel.com}" FAIL_ON_ERROR="${FAIL_ON_ERROR:-false}"

exec bash "$(dirname "$0")/deploy-marker.sh"
