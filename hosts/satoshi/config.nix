{ config, pkgs, lib, suites, profiles, hardware, hmUsers, ... }:

{
  imports = suites.full ++
    [ profiles.docker profiles.networks.iwd ] ++
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

  # Install full desktop environment
  home-manager.users.florian = hmUsers.florian-desktop;

  # Disable GPU unless overriden in specialization
  hardware.nvidiaOptimus.disable = lib.mkDefault true;

  boot = {
    # Recent and patched kernel for full hardware support
    kernelPackages = pkgs.linuxPackages_amd;

    # Fix backlight control
    kernelParams = [ "amdgpu.backlight=0" ];

    # Avoid touchpad race condition
    extraModprobeConfig = ''
      softdep i2c_hid pre: pinctrl_amd
      softdep usbhid pre: pinctrl_amd
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Use AMD CPU compatible bumblebee
  nixpkgs.overlays = [
    (self: super: { bumblebee = super.bumblebee_amd; })
  ];

  system.stateVersion = "21.11";
}
