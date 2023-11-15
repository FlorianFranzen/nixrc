{ config, pkgs, lib, profiles, homes, ...}:

{
  imports = 
    (with profiles; [ media mail office podman ]) ++
    (with profiles.develop; [
      minimal
      embedded
      extra
      cad
      manufac
      linux 
    ]) ++ 
    (with profiles.desktops; [ gdm sway ]) ++ 
    (with profiles.networks; [ iwd ]) ++ 
    (with profiles.hardware; [
      common-cpu-intel-sandy-bridge
      common-pc-laptop
      common-pc-laptop-ssd
      pipewire
      smartcard
    ]);

  # Install full desktop environment
  home-manager.users.florian = homes.desktop-solarized;

  boot = {
    # Latest kernel without wifi issues
    kernelPackages = pkgs.linuxPackages_latest;

    # Various kernel and module quirks
    kernelParams = [
      "i915.modeset=1"
      "i915.enable_fbc=1"
#      "usbcore.autosupend=1h"
      "i915.lvds_channel_mode=2"
    ];

    extraModprobeConfig = ''
      options sdhci debug_quirks2=4
      options snd-intel-dspcfg dsp_driver=1
    '';

    # Disable broken dedicated GPU
    blacklistedKernelModules = [ "admgpu" ];

    # Install boot loader to well-known location
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      enableCryptodisk = true;
      efiInstallAsRemovable = true;
    };
  };

  # Use more optimized fan control
  services.mbpfan.enable = true;

  # Hard disk protection in case of fall
  services.hdapsd.enable = lib.mkDefault true;

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "22.11";
}
