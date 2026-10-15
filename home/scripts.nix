{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "rofi-power";
      runtimeInputs = with pkgs; [ rofi swaylock hyprland ];
      text = ''
        chosen="$(printf "Block\nSuspend\nLogout\nReboot\nShutdown" | rofi -dmenu -i -p "System" || true)"

        case "$chosen" in
          "Block") swaylock ;;
          "Suspend") systemctl suspend ;;
          "Logout") hyprctl dispatch "hl.dsp.exit()" ;;
          "Reboot") systemctl reboot ;;
          "Shutdown") systemctl poweroff ;;
        esac
      '';
    })

    (pkgs.writeShellApplication {
      name = "rofi-wallpaper";
      runtimeInputs = with pkgs; [ rofi hyprpaper procps findutils ];
      text = ''
        WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
        CHOICE=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -printf '%f\n' | sort | rofi -dmenu -i -p "Wallpaper" || true)

        if [ -n "$CHOICE" ]; then
            # Kill hyprpaper if it was already running
            pkill hyprpaper || true
            # Generate temporary config
            CONFIG="/tmp/hyprpaper.conf"
            echo "preload = $WALLPAPER_DIR/$CHOICE" > "$CONFIG"
            echo "wallpaper = ,$WALLPAPER_DIR/$CHOICE" >> "$CONFIG"
            # Launch hyprpaper with the new config
            hyprpaper -c "$CONFIG" &
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "float-sdcv-kitty";
      runtimeInputs = with pkgs; [ rofi hyprland kitty sdcv less ];
      text = ''
        # Prompt for a word using rofi
        word="$(rofi -dmenu -p 'Define:' -i -no-fixed-num-lines -lines 0 || true)"
        [ -z "''${word:-}" ] && exit 0

        # Appearance configuration
        font_size=12.0
        fg_color="#E6E9FF"   # bright white
        bg_color="#222436"   # TokyoNight Moon background

        # Use Hyprland 0.55+ Lua API dispatcher with raw strings [[ ]]
        hyprctl dispatch "hl.dsp.exec_cmd([[ [float; size 900 700; center] kitty \
          --title sdcv \
          --override font_size=''${font_size} \
          --override foreground=''${fg_color} \
          --override background=''${bg_color} \
          bash -lc 'sdcv -n --utf8-output \"$word\" | less -R' ]])"
      '';
    })

    (pkgs.writeShellApplication {
      name = "rofi-newfile";
      runtimeInputs = with pkgs; [ rofi xdg-user-dirs neovim kitty ];
      text = ''
        # Resolve Desktop directory (works across locales)
        desktop_dir="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
        mkdir -p "$desktop_dir"

        # Prompt for file name
        name="$(rofi -dmenu -i -p 'File name' <<< "" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' || true)"
        [ -z "''${name}" ] && exit 0  # user cancelled or empty input

        # Force it onto the Desktop and avoid path traversal
        base="$(basename -- "$name")"
        path="''${desktop_dir}/''${base}"

        # Create the file if it doesn't exist
        [ -e "$path" ] || : > "$path"

        # Open with neovim in a terminal
        if command -v i3-sensible-terminal >/dev/null 2>&1; then
          i3-sensible-terminal -e nvim "$path" &
        elif [ -n "''${TERMINAL:-}" ]; then
          "$TERMINAL" -e nvim "$path" &
        elif command -v alacritty >/dev/null 2>&1; then
          alacritty -e nvim "$path" &
        elif command -v kitty >/dev/null 2>&1; then
          kitty nvim "$path" &
        else
          xterm -e nvim "$path" &
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "rofi-nixos-update";
      runtimeInputs = with pkgs; [ rofi hyprland kitty ];
      text = ''
        FLAKE="path:/home/agallas/nix-config#nixos"
        FLAKE_DIR="/home/agallas/nix-config"

        chosen="$(printf '%s\n' \
          "Update" \
          "Update + inputs" \
          "Update inputs only" \
          "Test" \
          "List generations" \
          "Garbage collect" \
          | rofi -dmenu -i -p "NixOS" -selected-row 0 || true)"

        [ -z "''${chosen:-}" ] && exit 0

        run_in_float() {
          local script="$1; echo; read -rp 'Press Enter to close...'"
          hyprctl dispatch "hl.dsp.exec_cmd([[ [float; size 1000 700; center] kitty \
            --title nixos-update \
            bash -lc $(printf '%q' "$script") ]])"
        }

        case "$chosen" in
          "Update")
            # Same as the shell `update` alias: rebuild + activate now
            run_in_float "sudo nixos-rebuild switch --flake \"$FLAKE\""
            ;;
          "Update + inputs")
            # Positional args to `nix flake update` are input names, so use --flake.
            # No sudo on update so flake.lock stays owned by you.
            run_in_float "nix flake update --flake \"$FLAKE_DIR\" && sudo nixos-rebuild switch --flake \"$FLAKE\""
            ;;
          "Update inputs only")
            run_in_float "nix flake update --flake \"$FLAKE_DIR\""
            ;;
          "Test")
            # Activate without writing a bootloader entry (easy to revert by reboot)
            run_in_float "sudo nixos-rebuild test --flake \"$FLAKE\""
            ;;
          "List generations")
            run_in_float "nixos-rebuild list-generations --flake \"$FLAKE\""
            ;;
          "Garbage collect")
            # Drop unreachable store paths / old generations
            run_in_float "sudo nix-collect-garbage -d"
            ;;
        esac
      '';
    })
  ];
}
