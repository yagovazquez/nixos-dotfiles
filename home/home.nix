{ config, pkgs, unstablePkgs, ... }:

{

  programs.home-manager.enable = true;
  home.username = "agallas";
  home.homeDirectory = "/home/agallas";
  home.stateVersion = "25.05";

  imports = [
    ./theme.nix
    ./scripts.nix
    ./programs/sh.nix
    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/zathura.nix
    ./programs/ghostty.nix
    ./programs/gtk.nix
    ./programs/qutebrowser.nix
    ./programs/rofi.nix
    ./programs/mako.nix
    ./programs/waybar.nix
    ./programs/languages/python.nix
    ./programs/languages/latex.nix
    ./configs/hypr/default.nix
  ];

  # Programs
  home.packages = with pkgs; [
	unstablePkgs.claude-code # stable channel lags upstream releases
	waybar
    google-chrome
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
    # VSCode 1.144.0 renamed its bundled @vscode/ripgrep to @vscode/ripgrep-universal
    # and moved the binary into a per-platform dir (bin/linux-x64/rg); nixpkgs'
    # postPatch still targets the old path, so the build fails. Point it at the
    # new location until nixpkgs catches up upstream.
    ((vscode.override { useVSCodeRipgrep = true; }).overrideAttrs (old: {
      postPatch = builtins.replaceStrings
        [ "node_modules/@vscode/ripgrep/bin/rg" ]
        [ "node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
        old.postPatch;
    })) # graphic code editor
    unstablePkgs.code-cursor # ai editor (from nixpkgs-unstable, stable channel lags upstream releases)
    gimp	inkscape		 # image edition
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

  # Yazi
  home.file.".config/yazi/yazi.toml".source = ./configs/yazi/yazi.toml;
}
