#!/usr/bin/env bash
# System info block

section() {
  printf "\033[36m%s\033[0m\n" "$1"
}

kv() {
  printf "  %-16s %s\n" "$1:" "$2"
}

HOST=$(hostname -s 2>/dev/null || hostname)
DATE_NOW=$(date +"%Y-%m-%d %H:%M")

# OS
if [[ "$(uname)" == "Darwin" ]]; then
    OS_NAME="macOS $(sw_vers -productVersion 2>/dev/null)"
    UPTIME=$(uptime | sed 's/.*up \([^,]*\),.*/\1/')
    LOAD=$(sysctl -n vm.loadavg 2>/dev/null | tr -d '{},' | awk '{print $1" "$2" "$3}')
    MEM_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
    MEM_GIB=$(( MEM_BYTES / 1024 / 1024 / 1024 ))
    DISK_ROOT=$(df -h / | awk 'NR==2{print $3 " used / " $2 " total (" $5 ")" }')
    IPS=$(ifconfig | awk '$1=="inet" && $2!="127.0.0.1" {print $2}' | paste -sd ", " -)
else
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        OS_NAME="${PRETTY_NAME:-Linux}"
    else
        OS_NAME="Linux"
    fi
    UPTIME=$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\),.*/\1/')
    LOAD=$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null)
    MEMORY=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 " used / " $2 " total"}')
    DISK_ROOT=$(df -h / 2>/dev/null | awk 'NR==2{print $3 " used / " $2 " total (" $5 ")"}')
    IPS=$(hostname -I 2>/dev/null | xargs)
fi

section "System"
kv "Host" "$HOST"
kv "OS" "$OS_NAME"
kv "Uptime" "$UPTIME"
[[ -n "$LOAD" ]] && kv "Load" "$LOAD"
[[ -n "$MEM_GIB" ]] && kv "Memory" "${MEM_GIB} GiB"
[[ -n "$MEMORY" ]] && kv "Memory" "$MEMORY"
kv "Disk /" "$DISK_ROOT"
kv "IP" "${IPS:-N/A}"
