#!/bin/bash
# Dotfiles installer for WSL2 / Ubuntu
# Usage: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing system packages..."
sudo apt update
sudo apt install -y \
    zsh \
    stow \
    curl \
    wget \
    git \
    unzip \
    jq \
    build-essential

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "==> Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# Homebrew
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
    echo "==> Installing GitHub CLI..."
    brew install gh
fi

# vscli (open VS Code from terminal)
if ! command -v vscli &>/dev/null; then
    echo "==> Installing vscli..."
    brew install vscli
fi

# NVM + Node
if [ ! -d "$HOME/.nvm" ]; then
    echo "==> Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo "==> Installing Node LTS..."
    nvm install --lts
fi

# Stripe CLI
if ! command -v stripe &>/dev/null; then
    echo "==> Installing Stripe CLI..."
    brew install stripe/stripe-cli/stripe
fi

# Claude Code
if ! command -v claude &>/dev/null; then
    echo "==> Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
fi

# Mergiraf (syntax-aware git merge driver)
if ! command -v mergiraf &>/dev/null; then
    echo "==> Installing Mergiraf..."
    cargo install --locked mergiraf
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "==> Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Stow dotfiles
echo "==> Stowing dotfiles..."
rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.gitconfig"
rm -f "$HOME/.config/git/attributes"
rm -f "$HOME/.oh-my-zsh/custom/aliases.zsh" "$HOME/.oh-my-zsh/custom/functions.zsh" "$HOME/.oh-my-zsh/custom/exports.zsh"

cd "$DOTFILES_DIR"
stow zsh
stow git

echo ""
echo "==> Done! Restart your terminal or run: source ~/.zshrc"
echo "    Run 'p10k configure' to set up the prompt theme."
echo "    Run 'gh auth login' to authenticate with GitHub."
