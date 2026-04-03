# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Herd Lite (PHP)
export PATH="/home/mreduar/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/mreduar/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Homebrew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# Cargo / Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/mreduar/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# OpenClaw Completion
[ -f "/home/mreduar/.openclaw/completions/openclaw.bash" ] && source "/home/mreduar/.openclaw/completions/openclaw.bash"
