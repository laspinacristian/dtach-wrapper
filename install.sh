#!/usr/bin/env bash
# Install:   curl -fsSL https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/install.sh | bash
# Uninstall: curl -fsSL https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/install.sh | bash -s -- --uninstall
#
# Installs the `attach` command in ~/.local/bin (override with PREFIX=/some/bin). No root needed.
set -euo pipefail

SOURCE_URL=https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/attach
BIN_DIR="${PREFIX:-$HOME/.local/bin}"
BIN="$BIN_DIR/attach"

die() { echo "Error: $*" >&2; exit 1; }

case "${1:-}" in
    --uninstall)
        rm -f -- "$BIN"
        echo "Removed $BIN."
        exit 0 ;;
    '') ;;
    *) die "unknown option: $1" ;;
esac

mkdir -p -- "$BIN_DIR"
tmp=$(mktemp)
trap 'rm -f -- "$tmp"' EXIT
local_copy="$(dirname -- "${BASH_SOURCE[0]:-/nonexistent}")/attach"
if [[ -f "$local_copy" ]]; then
    cp -- "$local_copy" "$tmp"
else
    curl -fsSL "$SOURCE_URL" -o "$tmp"
fi
bash -n "$tmp" || die 'downloaded script is not valid.'
install -m 0755 -- "$tmp" "$BIN"
echo "Installed $BIN."

missing=()
command -v dtach >/dev/null || missing+=(dtach)
command -v fuser >/dev/null || missing+=(fuser)
if (( ${#missing[@]} )); then
    echo "Warning: missing ${missing[*]}. Install it with your package manager, e.g.:"
    echo "  sudo dnf install dtach psmisc     # Fedora"
    echo "  sudo apt install dtach psmisc     # Debian/Ubuntu"
fi
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo "Note: $BIN_DIR is not in your PATH." ;;
esac
