{ config, pkgs, ... }:

{
  imports = [
    ./scripts.nix
    ./programs/sh.nix
    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/zathura.nix
    ./programs/ghostty.nix
    ./programs/gtk.nix
    ./programs/languages/python.nix
    ./programs/languages/latex.nix
  ];

  home.username = "agallas";
  home.homeDirectory = "/home/agallas";

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    udisks2

    #minecraft
    prismlauncher
    jdk25

    guix
    tetris

    vis

    qbittorrent
    stremio-linux-shell

    ffmpeg

    sqlite
    sqlitebrowser

    qutebrowser
    google-chrome
    libreoffice

    yazi

    sdcv  #dictionary

    discord
    wl-clipboard
    telegram-desktop
    obsidian             #note taking
    anki-bin             #flash cards
    vscode               # graphic code editor

    code-cursor

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

    unrar

    # Compiler toolchain (nvim was asking for c compiler)
    gcc
    gnumake
    gdb

    # LSPs
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
    rofi
    fastfetch

    # Hyprland enviroment extras
    waybar
    hyprpaper
    hyprlock
    hyprshot
    hyprsunset
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # --- Dotfiles / native app configs ---

  # Neovim (out-of-store for live editing)
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/configs/nvim";

  # Vis (out-of-store for live editing)
  xdg.configFile."vis".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/configs/vis";

  # qutebrowser
  home.file.".config/qutebrowser/config.py".source = ./configs/qutebrowser/config.py;

  # Yazi
  home.file.".config/yazi/yazi.toml".source = ./configs/yazi/yazi.toml;

  # Hyprland
  home.file.".config/hypr/hyprpaper.conf".source = ./configs/hypr/hyprpaper.conf;
  #home.file.".config/hypr/hyprland.conf".source = ./configs/hypr/hyprland.conf;
  home.file.".config/hypr/hyprland.lua".source = ./configs/hypr/hyprland.lua;

  xdg.configFile."waybar".source = ./configs/waybar;

  # Niri
  xdg.configFile."niri".source = ./configs/niri;

  # Rofi
  xdg.configFile."rofi".source = ./configs/rofi;
}
