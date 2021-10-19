{ config
, pkgs
, lib
, suites
, profiles
, services
, hardware
, ...
}:

{
  imports = (with suites; full)
    ++ (with profiles; [ docker gaming ])
    ++ (with profiles.develop; [ minimal emacs embedded extra manufac ])
    ++ (with profiles.desktops; [ lightdm sway ])
    ++ [ profiles.networks.iwd ]
    ++ (with hardware; [
      common-cpu-intel-sandy-bridge
      common-pc-laptop
      common-pc-laptop-ssd
      yubikey
    ]);

  # Needed for Wifi driver
  nixpkgs.config.allowUnfree = true;

  boot = {
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

  system.stateVersion = "20.03";
}
