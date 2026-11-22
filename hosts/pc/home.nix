# PC ONLY home-manager config, layered on top of the shared home/home.nix.
{ config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
  # Live-editable, like nvim: edit hosts/pc/labwc/* and run `labwc --reconfigure`.
  link = f: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/pc/labwc/${f}";
in
{
  # Release of the first home-manager install on this machine. Never change it.
  home.stateVersion = "26.05";

  # Spliced into home/configs/hypr/hyprland.lua in place of __MONITORS__.
  # The AOC's EDID prefers 60 Hz; it does 144 Hz over HDMI, so ask for it.
  # (labwc sets the same mode in ./labwc/autostart.)
  my.hyprland.monitors = ''
    hl.monitor({ output = "desc:AOC 24G2W1G4 0x00009CC8", mode = "1920x1080@144", position = "0x0", scale = "1" })
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
  '';

  # --- labwc (the lightweight session) ---
  xdg.configFile."labwc/rc.xml".source = link "rc.xml";
  xdg.configFile."labwc/menu.xml".source = link "menu.xml";
  xdg.configFile."labwc/autostart".source = link "autostart";
  xdg.configFile."labwc/environment".source = link "environment";

  # Window/menu colors from the shared palette (system/theme.nix).
  xdg.configFile."labwc/themerc-override".text = ''
    border.width: 1
    window.active.border.color: ${c.base0D}
    window.inactive.border.color: ${c.base03}
    window.active.title.bg.color: ${c.base01}
    window.inactive.title.bg.color: ${c.base00}
    window.active.label.text.color: ${c.base05}
    window.inactive.label.text.color: ${c.base03}
    window.active.button.unpressed.image.color: ${c.base05}
    window.inactive.button.unpressed.image.color: ${c.base03}
    menu.border.color: ${c.base02}
    menu.items.bg.color: ${c.base00}
    menu.items.text.color: ${c.base05}
    menu.items.active.bg.color: ${c.base02}
    menu.items.active.text.color: ${c.base07}
    osd.bg.color: ${c.base00}
    osd.border.color: ${c.base0D}
    osd.label.text.color: ${c.base05}
  '';

  # Waybar for labwc: the same bar, but with a window list instead of
  # Hyprland's workspaces (that module only works under Hyprland).
  xdg.configFile."waybar/labwc.jsonc".text = builtins.toJSON (config.programs.waybar.settings.mainBar // {
    "modules-left" = [ "wlr/taskbar" "cpu" "memory" "custom/timer" ];
    "wlr/taskbar" = {
      format = "{title:.30}";
      "on-click" = "activate";
      "on-click-middle" = "close";
    };
  });
}
