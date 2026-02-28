#!/usr/bin/env bash
# Tmux sessions block

if ! command -v tmux &>/dev/null; then
    return 0
fi

SESSIONS=$(tmux list-sessions 2>/dev/null)

if [[ -z "$SESSIONS" ]]; then
    return 0
fi

section "Tmux"
echo "$SESSIONS" | while read line; do
    kv "session" "$(echo "$line" | cut -d: -f1)"
done
