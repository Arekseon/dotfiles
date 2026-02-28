# ~/.zsh/welcome-ssh.zsh — SSH login banner

[[ -n "$ZSH_SSH_WELCOME_SHOWN" ]] && return
export ZSH_SSH_WELCOME_SHOWN=1

autoload -Uz colors && colors

hr() { print -P "%F{240}────────────────────────────────────────────────────────%f"; }
section() { print -P "%F{cyan}$1%f"; }
kv() { printf "  %-16s %s\n" "$1:" "$2"; }

print -P "%F{green}SSH session%f  %F{240}($(date +"%Y-%m-%d %H:%M"))%f"
hr

# Source all welcome.d scripts
for script in ~/.zsh/welcome.d/*.sh; do
    [[ -f "$script" ]] && source "$script"
done

hr
print -P "%F{240}Tip:%f use %F{yellow}tmux%f for persistent sessions; %F{yellow}uptime%f / %F{yellow}top%f / %F{yellow}df -h%f are your friends."
