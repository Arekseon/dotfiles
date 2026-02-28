#!/bin/bash
# wsl-install.sh — Bootstrap dotfiles on WSL/Linux

set -e

DOTFILES_REPO="${DOTFILES_REPO_URL:-https://github.com/arekseon/dotfiles.git}"

echo "==> Checking for ansible..."
if ! command -v ansible &>/dev/null; then
    echo "    Installing ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

echo "==> Cloning dotfiles repo..."
if [[ -d "$HOME/dotfiles" ]]; then
    echo "    Dotfiles already exist, pulling latest..."
    cd "$HOME/dotfiles" && git pull
else
    git clone "$DOTFILES_REPO" "$HOME/dotfiles"
fi

echo "==> Running ansible playbook..."
cd "$HOME/dotfiles/ansible"
ansible-playbook -i "localhost," playbooks/site.yml -c local --ask-become-pass

echo ""
echo "==> Done! Restart your shell or run: exec $SHELL"
