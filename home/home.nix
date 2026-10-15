{ config, pkgs, ... }:

{

  programs.home-manager.enable = true;
  home.username = "agallas";
  home.homeDirectory = "/home/agallas";
  home.stateVersion = "25.05";

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

    ./configs/hypr/default.nix
  ];

  # Programs
  home.packages = with pkgs; [
	waybar
    udisks2
    jdk25				 # minecraft
    tetris
    vis
    stremio-linux-shell
    ffmpeg
    qutebrowser
    sdcv  				 #dictionary
    discord
    wl-clipboard
    telegram-desktop
    obsidian             #note taking
    anki-bin             #flash cards
    vscode               # graphic code editor
    code-cursor 		 # ai editor
    gimp				 # image edition
    viewnior
    wget
    unrar
    fastfetch
    mpv
    rofi
    obs-studio			 # screen recorder

    # File manager and tools
    yazi
    ueberzugpp poppler ffmpegthumbnailer imagemagick chafa bat jq mediainfo p7zip unzip atool imagemagick          

    # Compiler toolchain (nvim was asking for c compiler)
    gcc gnumake gdb

    # Assembler (NASM) + asm LSP
    nasm asm-lsp

    # LSPs
    nixd lua-language-server pyright bash-language-server yaml-language-server clang-tools texlab

    # Zathura stuff
    girara gtk3

    # hardware control
    brightnessctl pamixer
  ];

  home.sessionVariables = {
    EDITOR = "vis";
    VISUAL = "vis";
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

  # Waybar
  xdg.configFile."waybar".source = ./configs/waybar;

  # Rofi
  xdg.configFile."rofi".source = ./configs/rofi;
}
