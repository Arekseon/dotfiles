#!/bin/bash
# Bootstrap script: run on a new machine to set up dotfiles
# Usage: curl -sL https://raw.githubusercontent.com/arekseon/dotfiles/main/install.sh | bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="${DOTFILES_REPO_URL:-https://github.com/arekseon/dotfiles.git}"

echo "==> Cloning dotfiles repo..."
if [[ -d "$DOTFILES_DIR" ]]; then
    echo "    Dotfiles directory exists, pulling latest..."
    cd "$DOTFILES_DIR" && git pull
else
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo "==> Creating symlinks..."
cd "$DOTFILES_DIR"

for file in .zshenv .zshrc .bashrc .tmux.conf; do
    if [[ -e "$HOME/$file" ]]; then
        echo "    Backing up existing $file"
        mv "$HOME/$file" "$HOME/$file.backup"
    fi
    echo "    Linking $file"
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
done

echo "==> Creating .zsh directory..."
mkdir -p "$HOME/.zsh"

echo "==> Checking for zsh..."
if command -v zsh &>/dev/null; then
    echo "    zsh is installed"
else
    echo "    WARNING: zsh not found. Install with: brew install zsh (Mac) or apt install zsh (Linux)"
fi

echo "==> Checking for starship..."
if command -v starship &>/dev/null; then
    echo "    starship is installed"
else
    echo "    WARNING: starship not found. Install with: curl -sS https://starship.rs/install.sh | sh"
fi

echo ""
echo "==> Done! Restart your shell or run: exec $SHELL"
