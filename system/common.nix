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

  networking.hostName = "nixos"; 
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "es";

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

  # TEMPORARY workaround for the dead battery (Nov 2026). On every resume the
  # kernel's battery driver asks the firmware for the battery's info, and the
  # firmware waits ~10 s (sometimes 20-30 s) for the dead pack to answer,
  # keeping the whole desktop frozen until it gives up. Detach the driver
  # from the battery before sleep and reattach it after resume, so that slow
  # query happens in the background instead. (Can't just disable the
  # `battery` module: thinkpad_acpi depends on it.)
  # Remove this once the dead battery is replaced or disconnected.
  powerManagement.powerDownCommands = ''
    echo PNP0C0A:00 > /sys/bus/acpi/drivers/battery/unbind || true
  '';
  powerManagement.resumeCommands = ''
    echo PNP0C0A:00 > /sys/bus/acpi/drivers/battery/bind || true
  '';

}
