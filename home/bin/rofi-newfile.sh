#!/usr/bin/env bash
set -euo pipefail

# Resolve Desktop directory (works across locales)
desktop_dir="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
mkdir -p "$desktop_dir"

# Prompt for file name
name="$(rofi -dmenu -i -p 'File name' <<< '' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
[ -z "${name}" ] && exit 0  # user cancelled or empty input

# Force it onto the Desktop and avoid path traversal
base="$(basename -- "$name")"
path="${desktop_dir}/${base}"

# Create the file if it doesn't exist
[ -e "$path" ] || : > "$path"

# Open with neovim in a terminal
if command -v i3-sensible-terminal >/dev/null 2>&1; then
  i3-sensible-terminal -e nvim "$path" &
elif [ -n "${TERMINAL:-}" ]; then
  "$TERMINAL" -e nvim "$path" &
elif command -v alacritty >/dev/null 2>&1; then
  alacritty -e nvim "$path" &
elif command -v kitty >/dev/null 2>&1; then
  kitty nvim "$path" &
else
  xterm -e nvim "$path" &
fi

