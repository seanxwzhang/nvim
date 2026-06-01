#!/usr/bin/env bash
#
# Install Sean's Neovim (AstroNvim) config onto a fresh machine.
#
#   curl -fsSL https://raw.githubusercontent.com/seanxwzhang/nvim/main/install.sh | bash
#
# It backs up any existing Neovim directories (config/data/state/cache) to a
# timestamped *.bak, clones this repo into your Neovim config dir, then leaves
# the first `nvim` launch to bootstrap lazy.nvim and install every plugin from
# the committed lazy-lock.json.
#
# Honors XDG_*; override the source with REPO_URL=... if you forked it.
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/seanxwzhang/nvim.git}"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

STAMP="$(date +%Y%m%d-%H%M%S)"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
info() { printf '  \033[36m•\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

bold "==> Checking prerequisites"
command -v git  >/dev/null 2>&1 || { echo "git is required but not found on PATH." >&2; exit 1; }
if command -v nvim >/dev/null 2>&1; then
  info "nvim found: $(nvim --version | head -1)"
else
  warn "nvim not found — install Neovim >= 0.10 before launching (https://github.com/neovim/neovim/releases)."
fi
# Soft dependencies — warn, don't fail.
for tool in codex claude rg node; do
  command -v "$tool" >/dev/null 2>&1 || warn "optional: '$tool' not on PATH (the agent panel / tooling expects it)."
done
warn "Make sure your terminal uses a Nerd Font (https://www.nerdfonts.com) for icons to render."

bold "==> Backing up existing Neovim directories"
backed_up=0
for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
  if [ -e "$dir" ]; then
    mv "$dir" "${dir}.bak.${STAMP}"
    info "moved $dir -> ${dir}.bak.${STAMP}"
    backed_up=1
  fi
done
[ "$backed_up" -eq 0 ] && info "nothing existing to back up — clean install."

bold "==> Cloning config"
git clone --depth 1 "$REPO_URL" "$CONFIG_DIR"
info "cloned $REPO_URL -> $CONFIG_DIR"

bold "==> Done"
cat <<EOF

  Next:
    1. Launch  nvim  — lazy.nvim bootstraps and installs every plugin pinned in
       lazy-lock.json. Let it finish, then quit and relaunch once.
    2. Run  :checkhealth  to spot any missing external tools.

  Your previous setup (if any) was preserved at *.bak.${STAMP}.
EOF
