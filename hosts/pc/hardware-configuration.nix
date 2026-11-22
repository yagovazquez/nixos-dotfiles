# PLACEHOLDER so the PC config can be checked before NixOS is installed.
# During the install this file is replaced by the real output of
# `nixos-generate-config --show-hardware-config` on the PC.
{ lib, ... }:

{
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
