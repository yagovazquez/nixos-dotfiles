# LAPTOP ONLY home-manager config, layered on top of the shared home/home.nix.
{ pkgs, ... }:

{
  # Release of the first home-manager install on this machine. Never change it.
  home.stateVersion = "25.05";

  home.packages = [
    # Rebuild the PC from the laptop: pushes to GitHub, then over SSH the PC
    # pulls into its own ~/nix-config and builds there. That keeps the PC's
    # clone in sync and nothing PC-only is ever downloaded onto the laptop.
    (pkgs.writeShellApplication {
      name = "deploy-pc";
      runtimeInputs = with pkgs; [ git openssh ];
      text = ''
        # Usage: deploy-pc [switch|test|boot]   (default: switch)
        action="''${1:-switch}"
        repo="$HOME/nix-config"

        if [ -n "$(git -C "$repo" status --porcelain)" ]; then
          echo "Uncommitted changes in $repo; commit them first (the PC only sees what's pushed)." >&2
          exit 1
        fi

        git -C "$repo" push
        ssh -t pc "cd ~/nix-config && git pull --ff-only && sudo nixos-rebuild $action --flake path:\$HOME/nix-config"
      '';
    })
  ];

  # Spliced into home/configs/hypr/hyprland.lua in place of __MONITORS__.
  my.hyprland.monitors = ''
    hl.monitor({ output = "eDP-1", mode = "1366x768", position = "0x0", scale = "1" })
    hl.monitor({ output = "desc:AOC 24G2W1G4 0x00009CC8", mode = "preferred", position = "-277x-1080", scale = "1" })
    -- TV Philips: its EDID prefers 1080p@50 (EU), force 60 Hz for smoother output.
    -- The TV overscans (crops the edges); `reserved` keeps windows/waybar inside the
    -- visible area (measured with a test pattern). Set to 0 if the TV's picture
    -- format is switched to "Sin escala"/unscaled.
  '';

  # Only a laptop has a battery and a backlight to show.
  programs.waybar.settings.mainBar."modules-right" = [ "battery" "backlight" "pulseaudio" "network" ];
}
