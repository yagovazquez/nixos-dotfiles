# LAPTOP ONLY. Nothing in this folder ever reaches the PC.
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Laptop-only home-manager bits (monitors, battery in waybar, ...).
  home-manager.users.agallas.imports = [ ./home.nix ];

  networking.hostName = "laptop";

  # VA-API driver for the HD 620 (Kaby Lake), so video decodes on the GPU:
  # Moonlight, browsers, mpv. Without it they all decode on the CPU.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # For the ESP32 usage
  services.udev.packages = with pkgs; [ platformio-core.udev ];

  # The NixOS release this machine was first installed with. Never change it
  # (it is NOT the release you're running; that's set in flake.nix).
  system.stateVersion = "25.05"; # Did you read the comment?
}
