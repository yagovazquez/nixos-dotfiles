# PC ONLY. Nothing in this folder ever reaches the laptop.
# Intel i5-9400F (no iGPU) · NVIDIA GTX 1060 6GB · 16 GB RAM
# Kingston A400 240 GB SSD (system) · Seagate BarraCuda 1 TB HDD (Windows + /data)
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./gaming.nix
    ./remote.nix
    ./labwc.nix
  ];

  # PC-only home-manager bits (labwc config, monitors, ...).
  home-manager.users.agallas.imports = [ ./home.nix ];

  networking.hostName = "pc";

  # Keyboard: Ziyoulang T8, US (ANSI) layout. The laptop is Spanish
  # (system/common.nix). Hyprland follows this; labwc: ./labwc/environment.
  services.xserver.xkb = { layout = "us"; variant = ""; };
  console.keyMap = "us";

  # HDD partition "Games-slow" (btrfs, kept from CachyOS): Steam library,
  # datasets. `nofail`: if the HDD dies or is unplugged, the PC still boots,
  # just without /data. The rest of the HDD is Windows' (left untouched).
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/301f5797-61df-4c4c-9c18-792b799a9e06";
    fsType = "btrfs";
    options = [ "nofail" "noatime" "x-systemd.device-timeout=10s" ];
  };

  # The NixOS release this machine was first installed with. Never change it
  # (it is NOT the release you're running; that's set in flake.nix).
  system.stateVersion = "26.05";
}
