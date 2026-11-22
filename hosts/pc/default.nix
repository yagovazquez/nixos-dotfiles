# PC ONLY. Nothing in this folder ever reaches the laptop.
# Intel i5-9400F (no iGPU) · NVIDIA GTX 1060 6GB · 16 GB RAM
# Kingston A400 240 GB SSD (system) · WD Blue 1 TB HDD (Windows leftover + /data)
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

  # 1 TB HDD: Steam library, datasets. `nofail`: if the HDD dies or is
  # unplugged, the PC still boots, just without /data.
  # TODO(install): fill in once we've seen the HDD's partitions.
  # fileSystems."/data" = {
  #   device = "/dev/disk/by-uuid/XXXX";
  #   fsType = "ext4";
  #   options = [ "nofail" "x-systemd.device-timeout=10s" ];
  # };

  # The NixOS release this machine was first installed with. Never change it
  # (it is NOT the release you're running; that's set in flake.nix).
  system.stateVersion = "26.05";
}
