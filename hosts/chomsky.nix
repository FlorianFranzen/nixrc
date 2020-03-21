{ config, pkgs, ... }:

{
  # Needed for Wifi driver
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelParams = [ 
      "radeon.modeset=0"
      "i915.modeset=1"
      "i915.enable_fbc=1"
#      "usbcore.autosupend=1h"
      "i915.lvds_channel_mode=2"
    ];
    
    # Better Intel GPU support
    kernelPackages = pkgs.linuxPackages_4_19;
 
    extraModprobeConfig = ''
      options sdhci debug_quirks2=4 
    '';
   
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      enableCryptodisk = true; 
      efiInstallAsRemovable = true;
   };

    supportedFilesystems = [ "zfs" ]; 
    
    zfs.enableUnstable = true;
  };

  networking = {
    hostName = "chomsky"; 
    hostId   = "c1093b49";
  };

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

}
