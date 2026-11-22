{ lib, pkgs, config, ... }:
{
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  # networking.hostName is set per machine, in hosts/<name>/default.nix.

  # Enable networking
  networking.networkmanager.enable = true;

  # Private network between my machines (laptop <-> PC), from anywhere.
  # One-time per machine: `sudo tailscale up`, then log in.
  services.tailscale.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;


  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Keyboard layout. mkDefault: a host with another keyboard overrides these
  # (the PC is US, see hosts/pc/default.nix). Hyprland reads `layout` too.
  services.xserver.xkb = {
    layout = lib.mkDefault "es";
    variant = lib.mkDefault "nodeadkeys";
  };

  # Console keymap (also the login screen, tuigreet).
  console.keyMap = lib.mkDefault "es";

  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.inconsolata
    ultimate-oldschool-pc-font-pack
  ];

  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;

  # Compressed swap in RAM. Idle unless memory fills up; then it compresses
  # cold pages instead of letting the OOM killer close apps.
  zramSwap.enable = true;

}
