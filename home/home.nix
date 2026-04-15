{ config, pkgs, ... }:

{

  imports = [
    ./sh.nix
    ./firefox/firefox.nix
    ./git.nix
    ./dotfiles.nix
    ./ranger/ranger.nix
    ./zathura.nix
    ./ghostty.nix
    ./helix.nix
    ./languages/python.nix
    ./languages/R.nix
    ./languages/ocaml.nix
    ./languages/nodejs.nix
  ];

  home.username = "agallas";
  home.homeDirectory = "/home/agallas";

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

    windsurf

    siyuan

    qbittorrent
    stremio

    ffmpeg

    sqlite
    sqlitebrowser

    qutebrowser
    google-chrome
    libreoffice

    yazi

    jetbrains.idea-community  #java ide
    jetbrains.pycharm-community
    sdcv  #dictionary

    discord
    wl-clipboard
    telegram-desktop
    obsidian             #note taking
    anki-bin             #flash cards
    vscode               # graphic code editor

    # Claude Code Wrapper
    # We use npx here because Claude Code actively refuses to run if it is even slightly outdated.
    # This hermetic script isolates the nodejs version and always guarantees the latest patch.
    (writeShellScriptBin "claude" ''
      export PATH="${nodejs}/bin:$PATH"
      exec npx -y @anthropic-ai/claude-code@latest "$@"
    '')

    # Images edition
    gimp
    
    # File manager
    kdePackages.dolphin
    ueberzugpp           # image previews in terminal
    poppler              # pdftoppm/pdftotext for PDFs
    ffmpegthumbnailer    # video thumbnails
    imagemagick          # image conversions as fallback
    chafa                # image/bitmap fallback (no graphics protocol)
    bat                  # pretty text/ code preview with syntax highlight
    jq                   # JSON pretty-print
    mediainfo            # media metadata in preview
    p7zip unzip atool    # archive listing/extract for preview
    imagemagick          # image edition
    viewnior
    wget
   
    # Compiler toolchain (nvim was asking for c compiler)
    gcc
    gnumake

    #LSPs 
    nixd                 # nix code corrector (for helix)
    lua-language-server
    pyright
    bash-language-server
    yaml-language-server
    vscode-langservers-extracted
    clang-tools
    texlab

    # Zathura stuff
    girara
    gtk3    

    # Screen recorder
    obs-studio

    # hardware control
    brightnessctl
    pamixer
    mpv
    rofi-wayland
    neofetch
    fastfetch
    
    # Sway enviroment extras
    swaybg

    # Hyprland enviroment extras
    waybar
    hyprpaper
    hyprlock
    hyprshot
    hyprsunset

  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "NineIcons";   
      package = null;       
    };
    theme = {
      name = "Catppuccin-Mocha-Dark";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
