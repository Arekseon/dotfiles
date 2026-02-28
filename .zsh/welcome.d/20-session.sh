#!/usr/bin/env bash
# Session info block (only for SSH sessions)

if [[ -z "$SSH_CONNECTION" && -z "$SSH_TTY" ]]; then
    return 0
fi

section() {
  printf "\033[36m%s\033[0m\n" "$1"
}

kv() {
  printf "  %-16s %s\n" "$1:" "$2"
}

SSH_FROM="${SSH_CONNECTION%% *}"
SSH_TTY_DEV="${SSH_TTY:-N/A}"
WHO_COUNT=$(who | wc -l | tr -d ' ')

section "Session"
kv "User" "$USER"
kv "From" "${SSH_FROM:-N/A}"
kv "TTY" "$SSH_TTY_DEV"
kv "Logins" "$WHO_COUNT"
