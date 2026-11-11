{ config, lib, ... }:

let
  # style.css's `@define-color` block already carries the exact TokyoNight
  # Night values it was hand-tuned against as defaults, so when that's the
  # active scheme no override is needed — the file stays pixel-identical
  # to before. Every other scheme gets those same colors redefined from
  # the live base16 palette, appended after the stylesheet so the later
  # `@define-color` declarations win (GTK CSS resolves each `@name` to its
  # most-recently-defined value).
  isTokyonight = builtins.elem config.lib.stylix.colors.slug [ "tokyonight-night" "tokyonight-moon" ];
  c = config.lib.stylix.colors.withHashtag;
  paletteOverride = ''

    @define-color bg ${c.base01};
    @define-color fg ${c.base05};
    @define-color border ${c.base02};
    @define-color separator ${c.base00};
    @define-color accent-active ${c.base0E};
    @define-color urgent ${c.base08};
    @define-color good ${c.base0B};
    @define-color warn ${c.base0A};
    @define-color charging ${c.base0B};
    @define-color muted ${c.base03};
    @define-color clock-color ${c.base0D};
    @define-color net-ok ${c.base0C};
    @define-color hover ${c.base02};
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    style = builtins.readFile ../configs/waybar/style.css
      + lib.optionalString (!isTokyonight) paletteOverride;

    settings.mainBar = {
      position = "top";
      layer = "top";
      height = 15;
      spacing = 4;

      "modules-left" = [ "image" "hyprland/workspaces" "cpu" "memory" "custom/timer" ];
      "modules-center" = [ "clock" ];
      "modules-right" = [ "battery" "backlight" "pulseaudio" "network" ];

      image = {
        path = "/home/agallas/nix-config/xfce4-workspaces.png";
        size = 13;
        tooltip = false;
      };

      "hyprland/workspaces" = {
        format = "{icon}{id}";
        "active-only" = false;
        "all-outputs" = false;
        "show-special" = false;
        "persistent-only" = false;

        "format-icons" = {
          active = ">";
          visible = "";
          empty = "";
          special = "";
          default = "";
        };
      };

      cpu = {
        interval = 5;
        format = "CPU: {usage}%";
      };

      memory = {
        interval = 5;
        format = "RAM: {used:0.1f}G/{total:0.1f}G ({percentage}%)";
      };

      "custom/timer" = {
        exec = "~/nix-config/home/configs/waybar/waybar-timer.sh print";
        "return-type" = "json";
        interval = 1;
        signal = 5;
        tooltip = false;
        format = "{}";
      };

      network = {
        interval = 5;
        "format-wifi" = "WiFi: {essid} {signalStrength}%";
        "format-ethernet" = "ETH: {ifname}";
        "format-disconnected" = "No net";
        "on-click" = "kitty -e nmtui";
      };

      battery = {
        interval = 15;
        states = {
          good = 100;
          warning = 30;
          critical = 10;
        };
        format = "BAT: {capacity}%";
        "format-charging" = "CHR: {capacity}%";
        "format-plugged" = "AC: {capacity}%";
      };

      backlight = {
        format = "BRI: {percent}%";
        "on-scroll-up" = "brightnessctl set +5%";
        "on-scroll-down" = "brightnessctl set 5%-";
      };

      pulseaudio = {
        format = "VOL: {volume}%";
        "format-muted" = "VOL: MUTE";
        "on-click" = "pamixer -t";
        "on-scroll-up" = "pamixer -i 5";
        "on-scroll-down" = "pamixer -d 5";
      };

      clock = {
        interval = 60;
        format = "{:%H:%M}";
        "tooltip-format" = "{:%Y-%m-%d %A}";
      };
    };
  };
}
