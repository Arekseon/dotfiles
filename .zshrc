# .zshrc - sourced by interactive zsh shells

# Guard: only run if interactive
[[ -o interactive ]] || return

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# --- Navigation ---
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'

# --- Completion ---
autoload -Uz compinit
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
mkdir -p "${ZSH_COMPDUMP:h}"
compinit -d "$ZSH_COMPDUMP"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Colors ---
autoload -Uz colors && colors

# --- Editor ---
export EDITOR=nano
export VISUAL=nano

# --- Safe aliases ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Nice aliases ---
alias ll='ls -FGlAhp'
alias la='ls -AG'
alias l='ls -CFGal'
alias less='less -FSRXc'

# --- Functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar e "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# --- OS-specific PATH ---
typeset -U path PATH

# macOS (Apple Silicon)
if [[ -d /opt/homebrew/bin ]]; then
    path=(
        /opt/homebrew/bin
        /opt/homebrew/sbin
        $path
    )
fi

# macOS (Intel)
if [[ -d /usr/local/bin ]]; then
    path=(
        /usr/local/bin
        /usr/local/sbin
        $path
    )
fi

# Linux (Homebrew)
if [[ -d ~/.linuxbrew/bin ]]; then
    path=(
        ~/.linuxbrew/bin
        ~/.linuxbrew/sbin
        $path
    )
fi

export PATH

# --- Zsh plugins (if installed) ---
# Syntax highlighting
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Auto suggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- Starship prompt ---
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# --- SSH welcome message ---
if [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]]; then
    if [[ -f ~/.zsh/welcome-ssh.zsh ]]; then
        source ~/.zsh/welcome-ssh.zsh
    fi
else
    # Local interactive shell welcome
    if [[ -f ~/.zsh/welcome.zsh ]]; then
        source ~/.zsh/welcome.zsh
    fi
fi
