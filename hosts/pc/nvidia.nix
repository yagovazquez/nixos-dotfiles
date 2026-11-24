# PC ONLY: NVIDIA GTX 1060 (a "Pascal" card), the PC's only GPU.
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # The default driver on nixos-26.05 (595.x) dropped Pascal cards; the
    # 580 series is the last one that supports the GTX 1060.
    # Keep the default kernel too: legacy drivers lag behind brand-new
    # kernels, so don't switch boot.kernelPackages to linuxPackages_latest.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    # NVIDIA's open kernel module only supports GTX 16xx / RTX and newer.
    open = false;
    # Required by Wayland compositors (Hyprland, labwc).
    modesetting.enable = true;
    # Keeps video memory across suspend, so the desktop comes back intact
    # if the PC is suspended instead of powered off.
    powerManagement.enable = true;
  };

  # Hardware video decoding (mpv, Firefox) through VA-API.
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  # From Hyprland's NVIDIA page; harmless for labwc.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Firefox decodes video in its sandboxed RDD process, which can't reach
    # the driver's /dev/nvidia* devices (nvidia-vaapi-driver's README).
    # Firefox's prefs for it are in ./home.nix.
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
