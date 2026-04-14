#!/usr/bin/env bash
# ==============================================================================
# Dotfiles bootstrap script
# Usage: bash install.sh
# ==============================================================================

set -e

DOTFILES_REPO="git@github.com:lsamon/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

alias dotfiles="git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Dotfiles installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ------------------------------------------------------------------------------
# 1. Check dependencies
# ------------------------------------------------------------------------------
echo ""
echo "→ Checking dependencies..."

if ! command -v git &>/dev/null; then
  echo "  git not found. Installing..."
  sudo apt update && sudo apt install -y git
else
  echo "  git OK"
fi

# ------------------------------------------------------------------------------
# 2. Clone the bare repo (skip if already exists)
# ------------------------------------------------------------------------------
echo ""
echo "→ Cloning dotfiles repo..."

if [ -d "$DOTFILES_DIR" ]; then
  echo "  $DOTFILES_DIR already exists, skipping clone."
else
  git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo "  Cloned to $DOTFILES_DIR"
fi

# ------------------------------------------------------------------------------
# 3. Checkout dotfiles — back up any conflicting files first
# ------------------------------------------------------------------------------
echo ""
echo "→ Checking out dotfiles..."

mkdir -p "$BACKUP_DIR"

# Attempt checkout; if it fails, back up conflicting files and retry
if ! dotfiles checkout 2>/dev/null; then
  echo "  Conflicts found — backing up existing files to $BACKUP_DIR"
  dotfiles checkout 2>&1 \
    | grep -E "^\s+\." \
    | awk '{print $1}' \
    | while read -r file; do
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
        echo "  Backed up: $file"
      done
  dotfiles checkout
fi

echo "  Checkout complete"

# ------------------------------------------------------------------------------
# 4. Configure repo
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuring dotfiles repo..."
dotfiles config --local status.showUntrackedFiles no
echo "  Done"

# ------------------------------------------------------------------------------
# 5. Reload shell config
# ------------------------------------------------------------------------------
echo ""
echo "→ Reloading shell config..."
# shellcheck disable=SC1090
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc" && echo "  .bashrc reloaded"

# ------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  All done! Your dotfiles are set up."
echo ""
echo "  Backed up files (if any): $BACKUP_DIR"
echo "  Use 'dotfiles' instead of 'git' to manage your configs."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
