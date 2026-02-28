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

alias RELOAD_ZSHRC='source ~/.zshrc'

# --- Edit configs ---
# Determine editor: nano for SSH, sublime for local desktop
edit() {
    local editor
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]]; then
        editor="nano"
    elif command -v subl &>/dev/null; then
        editor="subl"
    else
        editor="nano"
    fi
    $editor "$@"
}

alias ZSHRCING='edit ~/.zshrc && source ~/.zshrc'
alias GHOSTTY_CONFIG='edit ~/Library/Application\ Support/com.mitchellh.ghostty/config 2>/dev/null || echo "Ghostty config not found"'

# --- Ghostty ---
alias ghostty-terminfo='infocmp -x xterm-ghostty | ssh $1 "tic -x -"'

# --- CLI alternatives ---
CLI_ALTERNATIVES=(
    "bat > cat"
    "eza > ls"
    "fd > find"
    "rg > grep"
)
alternatives() {
    echo "Consider upgrading these commands:"
    for alt in "${CLI_ALTERNATIVES[@]}"; do
        echo "  $alt"
    done
}

# --- IP address (cross-platform) ---
ip() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ifconfig | awk '$1=="inet" && $2!="127.0.0.1" {print $2}'
    else
        hostname -I
    fi
}

# --- Update dotfiles ---
update-dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    local repo_url="${DOTFILES_REPO_URL:-https://github.com/arekseon/dotfiles.git}"

    if [[ -d "$dotfiles_dir/.git" ]]; then
        echo "==> Checking for dotfiles updates..."
        cd "$dotfiles_dir"
        git fetch origin main
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)
        
        if [[ "$LOCAL" == "$REMOTE" ]]; then
            echo "    Dotfiles are up to date."
            return 0
        fi
        
        echo "    Updates available, pulling..."
        git pull
    else
        echo "==> Cloning dotfiles..."
        git clone "$repo_url" "$dotfiles_dir"
    fi

    echo "==> Running ansible locally..."
    cd "$dotfiles_dir/ansible"
    ansible-playbook -i "localhost," playbooks/site.yml -c local --ask-become-pass
}

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
