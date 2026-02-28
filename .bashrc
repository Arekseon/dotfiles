# .bashrc - sourced by interactive bash shells (non-login)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# --- History ---
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth
shopt -s histappend

# --- Window size ---
shopt -s checkwinsize

# --- Navigation ---
shopt -s autocd 2>/dev/null  # Bash 4+ only

# --- Editor ---
export EDITOR=nano
export VISUAL=nano

# --- Colors (ls, grep) ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# --- Safe aliases ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Nice aliases ---
alias ll='ls -FGlAhp'
alias la='ls -A'
alias l='ls -CF'

alias RELOAD_BASHRC='source ~/.bashrc'

# --- Edit configs ---
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

alias BASHRCCING='edit ~/.bashrc && source ~/.bashrc'
alias GHOSTTY_CONFIG='edit ~/Library/Application\ Support/com.mitchellh.ghostty/config 2>/dev/null || echo "Ghostty config not found"'

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

# --- Functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }

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

# --- Completion ---
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# --- Starship prompt ---
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# --- SSH welcome ---
if [[ -n "$SSH_CONNECTION" && -z "$BASH_SSH_WELCOME_SHOWN" ]]; then
    export BASH_SSH_WELCOME_SHOWN=1
    if [[ -f ~/.bash_welcome ]]; then
        source ~/.bash_welcome
    fi
fi
