#!/usr/bin/env bash
# ASCII art hostname block

if ! command -v figlet &>/dev/null; then
    return 0
fi

HOST=$(hostname -s)

if command -v lolcat &>/dev/null; then
    figlet -w 60 "$HOST" | lolcat
else
    figlet -w 60 "$HOST"
fi
