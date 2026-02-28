# .zshenv - sourced by all zsh invocations (login, interactive, scripts)
# Keep minimal - this runs for EVERY zsh process

# Ensure we start in home directory
cd ~ 2>/dev/null || true

# User-local binaries
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# uv (Python package manager)
export PATH="$HOME/.local/bin:$PATH"

# XDG Base Directory (optional but clean)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
