#!/usr/bin/env bash
# Idempotent setup for nvim-adjacent configs.
# Safe to re-run. Won't overwrite existing user files - only creates missing symlinks.

set -u

NVIM_DIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

link() {
    local source="$1"
    local target="$2"
    local name
    name="$(basename "$target")"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        ok "$name: already linked"
    elif [ -e "$target" ] || [ -L "$target" ]; then
        warn "$name: $target exists but isn't the expected symlink - resolve manually"
    else
        mkdir -p "$(dirname "$target")"
        ln -s "$source" "$target"
        ok "$name: linked -> $source"
    fi
}

echo "Setting up nvim-adjacent configs..."

# Lazygit config (for the G commit-message keybind)
link "$NVIM_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
