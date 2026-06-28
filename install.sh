#!/usr/bin/env bash
#
# Dotfiles installer.
#
# The dev container's dotfiles support clones this repo to ~/dotfiles and runs
# this script automatically; it also works run by hand from any checkout.
# Everything in the repo is copied straight into $HOME, MERGING directories
# (e.g. .config) into whatever is already there and overwriting same-named files.
set -euo pipefail

# Repo root = the directory holding this script, so the source is correct whether
# this is invoked from ~/dotfiles or any other checkout location.
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}"

echo "Installing dotfiles from ${SRC} into ${DEST}"

# tar (not cp) copies the tree: it merges directories at any depth and overwrites
# files cleanly. `cp -a .config ~` would nest into ~/.config/.config when
# ~/.config already exists. The only things not copied are repo machinery:
#   .git       -- copying it would turn $HOME into a git working tree
#   install.sh -- this script itself
tar -C "${SRC}" \
    --exclude='./.git' \
    --exclude='./install.sh' \
    -cf - . \
| tar -C "${DEST}" -xf -

echo "Dotfiles installed."
