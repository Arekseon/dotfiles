# ~/.zsh/welcome-ssh.zsh — SSH login banner (macOS)

# Run once per SSH login shell
[[ -n "$ZSH_SSH_WELCOME_SHOWN" ]] && return
export ZSH_SSH_WELCOME_SHOWN=1

autoload -Uz colors && colors

hr() { print -P "%F{240}────────────────────────────────────────────────────────%f"; }
section() { print -P "%F{cyan}$1%f"; }
kv() { printf "  %-16s %s\n" "$1:" "$2"; }

# --- Gather info (fast, macOS-native) ---
HOST=$(hostname -s)
DATE_NOW=$(date +"%Y-%m-%d %H:%M")
OS_NAME="macOS $(sw_vers -productVersion 2>/dev/null)"

# Uptime (pretty)
UPTIME=$(uptime | sed 's/.*up \([^,]*\),.*/\1/')

# Load averages
LOAD=$(sysctl -n vm.loadavg 2>/dev/null | tr -d '{},' | awk '{print $1" "$2" "$3}')

# CPU model (optional, nice)
CPU=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)

# Memory (bytes -> GiB)
MEM_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
MEM_GIB=$(( MEM_BYTES / 1024 / 1024 / 1024 ))

# Disk usage (root)
DISK_ROOT=$(df -h / | awk 'NR==2{print $3 " used / " $2 " total (" $5 ")"}')

# IPs: show all active IPv4 (non-loopback)
IPS=$(ifconfig | awk '
  $1=="inet" && $2!="127.0.0.1" {print $2}
' | paste -sd ", " -)

# SSH info
SSH_FROM="${SSH_CONNECTION%% *}"
SSH_TTY_DEV="${SSH_TTY:-N/A}"

# User sessions
WHO_COUNT=$(who | wc -l | tr -d ' ')

print -P "%F{green}SSH session%f  %F{240}(${DATE_NOW})%f"
hr

section "System"
kv "Host"    "$HOST"
kv "OS"      "$OS_NAME"
[[ -n "$CPU" ]] && kv "CPU" "$CPU"
kv "Uptime"  "$UPTIME"
kv "Load"    "${LOAD:-N/A}"
kv "Memory"  "${MEM_GIB} GiB"
kv "Disk /"  "$DISK_ROOT"
kv "IP"      "${IPS:-N/A}"

section "Session"
kv "User"    "$USER"
kv "From"    "${SSH_FROM:-N/A}"
kv "TTY"     "$SSH_TTY_DEV"
kv "Logins"  "$WHO_COUNT"

hr

# Small hint line (DietPi-ish)
print -P "%F{240}Tip:%f use %F{yellow}tmux%f for persistent sessions; %F{yellow}uptime%f / %F{yellow}top%f / %F{yellow}df -h%f are your friends."

