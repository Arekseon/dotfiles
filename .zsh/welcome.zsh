# ~/.zsh/welcome.zsh — Local interactive shell welcome

[[ -n "$ZSH_LOCAL_WELCOME_SHOWN" ]] && return
export ZSH_LOCAL_WELCOME_SHOWN=1

autoload -Uz colors && colors

hr() { print -P "%F{240}────────────────────────────────────────────────────────%f"; }
section() { print -P "%F{cyan}$1%f"; }
kv() { printf "  %-16s %s\n" "$1:" "$2"; }

print -P "%F{green}Welcome back, %n%f  %F{240}($(date +"%Y-%m-%d %H:%M"))%f"
hr

# Source all welcome.d scripts
for script in ~/.zsh/welcome.d/*.sh; do
    [[ -f "$script" ]] && source "$script"
done

hr
