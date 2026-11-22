# LAPTOP ONLY. Nothing in this folder ever reaches the PC.
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Laptop-only home-manager bits (monitors, battery in waybar, ...).
  home-manager.users.agallas.imports = [ ./home.nix ];

  networking.hostName = "laptop";

  # For the ESP32 usage
  services.udev.packages = with pkgs; [ platformio-core.udev ];

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

  # The NixOS release this machine was first installed with. Never change it
  # (it is NOT the release you're running; that's set in flake.nix).
  system.stateVersion = "25.05"; # Did you read the comment?
}
