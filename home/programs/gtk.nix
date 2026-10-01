{ config, pkgs, ... }:

let
  nineIcons = pkgs.stdenvNoCC.mkDerivation {
    pname = "nineicons";
    version = "0-unstable-2026-10-01";
    src = pkgs.fetchFromGitHub {
      owner = "yagovazquez";
      repo = "icons";
      rev = "34642a0d3ddb5212ba80613b1540a40c92e8d9b6";
      hash = "sha256-hflTZsHo5H+oitZ7pK7TWq3aRqZ92yMoRRg65UH1NDw=";
    };
    nativeBuildInputs = [ pkgs.gtk3 pkgs.file ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      themeDir=$out/share/icons/NineIcons
      mkdir -p $out/share/icons
      cp -r NineIcons "$themeDir"
      chmod -R u+w "$themeDir"

      # Drop non-PNG "png" files (ICO/garbage) — they invalidate the icon cache.
      find "$themeDir" -type f -name '*.png' -print0 | while IFS= read -r -d "" f; do
        ft=$(file -b "$f")
        case "$ft" in
          'PNG image'*) ;;
          *) rm -f "$f" ;;
        esac
      done

      # Filenames with spaces also make gtk-update-icon-cache fail.
      find "$themeDir" -name '* *' -delete

      # Upstream index.theme lists many directories that are not shipped.
      dirs=$(
        find "$themeDir" -mindepth 2 -maxdepth 2 -type d \
          | sed "s|^$themeDir/||" \
          | sort \
          | paste -sd, -
      )

      {
        echo '[Icon Theme]'
        echo 'Name=NineIcons'
        echo 'Comment=A modern theme for a Cop Land'
        echo 'Inherits=Adwaita,hicolor'
        echo "Directories=$dirs"
        echo

        find "$themeDir" -mindepth 2 -maxdepth 2 -type d \
          | sed "s|^$themeDir/||" \
          | sort \
          | while IFS= read -r d; do
              size=''${d##*/}
              context=''${d%/*}
              case "$context" in
                actions) ctx=Actions ;;
                apps) ctx=Applications ;;
                categories) ctx=Categories ;;
                devices) ctx=Devices ;;
                mimes) ctx=MimeTypes ;;
                places) ctx=Places ;;
                *) ctx=Applications ;;
              esac
              echo "[$d]"
              echo "Size=$size"
              echo "Context=$ctx"
              echo 'Type=Fixed'
              echo
            done
      } > "$themeDir/index.theme"

      gtk-update-icon-cache -f "$themeDir"

      runHook postInstall
    '';
  };
in
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
      package = nineIcons;
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
      icon-theme = "NineIcons";
    };
  };
}
