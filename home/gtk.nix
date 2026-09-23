{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    thunar
    gvfs                 # trash, mounts, remote files in Thunar
    adwaita-icon-theme   # NineIcons inherits from Adwaita; required for Thunar icons
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "NineIcons";
      package = null; # installed under ~/.icons
    };
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    colorScheme = "dark";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
    # Tokyonight (and similar GNOME-oriented themes) style CSD toolbar buttons as
    # full pills/circles. That selector matches Thunar's pathbar and toolbar and
    # makes the UI look broken; keep those controls compact and squared-off.
    gtk3.extraCss = ''
      /* Thunar-only font; global GTK font stays Noto Sans */
      .thunar {
        font-family: "MxPlus IBM VGA 9x16";
        font-size: 11pt;
      }

      window.thunar.csd > box.vertical > box.vertical > toolbar.horizontal > toolitem > .linked > button,
      window.thunar.csd > box.vertical > box.vertical > toolbar.horizontal > toolitem > box.horizontal > button,
      window.thunar.solid-csd > box.vertical > box.vertical > toolbar.horizontal > toolitem > .linked > button,
      window.thunar.solid-csd > box.vertical > box.vertical > toolbar.horizontal > toolitem > box.horizontal > button,
      .thunar toolbar button,
      .thunar .path-bar.linked > button {
        min-height: 28px;
        min-width: 28px;
        padding: 2px 6px;
        border-radius: 6px;
      }

      .thunar .path-bar.linked > button:first-child {
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
      }

      .thunar .path-bar.linked > button:last-child {
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;
      }
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
