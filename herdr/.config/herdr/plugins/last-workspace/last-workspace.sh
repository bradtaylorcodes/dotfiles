#!/usr/bin/env bash

set -euo pipefail

# State is two lines: the current workspace id, then the previous one.
herdr="${HERDR_BIN_PATH:-herdr}"
state="${HERDR_PLUGIN_STATE_DIR:?}/history"

focused_workspace() {
  "$herdr" workspace list | jq -r '.result.workspaces[] | select(.focused) | .workspace_id' | head -n 1
}

read_state() {
  current="" previous=""
  [[ -f "$state" ]] || return 0
  { IFS= read -r current || true; IFS= read -r previous || true; } <"$state"
}

case "${1:-}" in
  record)
    # the event payload names the workspace; startup has no payload, so ask herdr
    id=$(jq -r '.. | .workspace_id? // empty' <<<"${HERDR_PLUGIN_EVENT_JSON:-null}" | head -n 1)
    [[ -n "$id" ]] || id=$(focused_workspace)
    [[ -n "$id" ]] || exit 0
    read_state
    [[ "$id" == "$current" ]] && exit 0
    printf '%s\n%s\n' "$id" "$current" >"$state"
    ;;
  switch)
    read_state
    [[ -n "$previous" ]] || exit 0
    # the previous workspace may have been closed since
    if "$herdr" workspace list | jq -e --arg id "$previous" 'any(.result.workspaces[]; .workspace_id == $id)' >/dev/null; then
      "$herdr" workspace focus "$previous" >/dev/null
    fi
    ;;
  *)
    echo "usage: last-workspace.sh record|switch" >&2
    exit 2
    ;;
esac
