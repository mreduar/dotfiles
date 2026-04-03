#!/bin/bash
# Dotfiles installer
# Usage: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install stow if not present
if ! command -v stow &>/dev/null; then
    echo "Installing stow..."
    sudo apt install stow -y
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k if not present
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Remove existing files that would conflict with stow
echo "Removing existing files to create symlinks..."
rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.gitconfig"
rm -f "$HOME/.oh-my-zsh/custom/aliases.zsh" "$HOME/.oh-my-zsh/custom/functions.zsh" "$HOME/.oh-my-zsh/custom/exports.zsh"

# Stow all packages
cd "$DOTFILES_DIR"
echo "Stowing packages..."
stow zsh
stow git

echo "Done! Restart your terminal or run: source ~/.zshrc"
