#!/usr/bin/env bash
# ~/.zsh/welcome.zsh — Welcome message for interactive shells

hr() {
  printf "\033[90m────────────────────────────────────────────────────────\033[0m\n"
}

section() {
  printf "\033[36m%s\033[0m\n" "$1"
}

kv() {
  printf "  %-16s %s\n" "$1:" "$2"
}

HOST=$(hostname -s 2>/dev/null || hostname)
DATE_NOW=$(date +"%Y-%m-%d %H:%M")

# OS
OS_NAME=$(uname -s)
if [[ "$OS_NAME" == "Darwin" ]]; then
  OS_NAME="macOS $(sw_vers -productVersion 2>/dev/null || uname -r)"
fi

# Uptime
if [[ "$OS_NAME" == "Darwin" ]]; then
  UPTIME=$(uptime | sed 's/.*up //' | sed 's/,.*//')
else
  UPTIME=$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\),.*/\1/')
fi

# IP
if [[ "$OS_NAME" == "Darwin" ]]; then
  IP=$(ipconfig getifaddr en0 2>/dev/null || echo "N/A")
else
  IP=$(hostname -I 2>/dev/null | xargs || echo "N/A")
fi

# Shell
SHELL=$(basename "$SHELL")
TERM="${TERM:-unknown}"

printf "\n\033[32mWelcome back, $(whoami)\033[0m\n"
hr

section "System"
kv "Host" "$HOST"
kv "OS" "$OS_NAME"
kv "Uptime" "$UPTIME"
kv "IP" "$IP"

section "Shell"
kv "Shell" "$SHELL"
kv "Terminal" "$TERM"
kv "Time" "$DATE_NOW"

hr
printf "\n"
