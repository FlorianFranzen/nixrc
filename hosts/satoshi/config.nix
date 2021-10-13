{ config, pkgs, lib, suites, profiles, hardware, ... }:

{

  imports = suites.full ++
    [ profiles.docker profiles.networks.iwd ] ++
    (with profiles.develop; [ minimal emacs extra ]) ++
    (with profiles.desktops; [ lightdm sway ]) ++
    (with hardware; [
      common-cpu-amd
      common-gpu-amd
      common-gpu-nvidia-disable
      common-pc-laptop
      common-pc-ssd
      yubikey
    ]);

  boot = {
    # Latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;

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
