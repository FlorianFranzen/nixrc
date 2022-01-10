{ config, pkgs, lib, suites, profiles, hardware, ... }:

{
  imports = suites.full ++
    [ profiles.docker profiles.networks.iwd profiles.waydroid ] ++
    (with profiles.develop; [ minimal emacs extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with hardware; [
      common-cpu-amd
      common-gpu-amd
      common-pc-laptop
      common-pc-ssd
      yubikey
      zsa
    ]);

  # Disable GPU unless overriden in specialization
  hardware.nvidiaOptimus.disable = lib.mkDefault true;

  boot = {
    # Latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [ 
      # Avoid nouveau failing to initialize discrete gpu
      "nouveau" 
      # Disable, useless without working video
      "snd_hda_codec_hdmi"
    ];  

    # Fix backlight control
    kernelParams = [ "amdgpu.backlight=0" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "21.05"; 
}
