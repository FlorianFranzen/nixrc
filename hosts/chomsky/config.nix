{ config, pkgs, lib,  ... }:

let
  nixrc = {
    profiles = [ "full" "virtual" "docker" "gaming" ];
    develop  = [ "default" "extra" "manufac" ];
    desktops = [ "sway" "i3" ];
    networks = [ "iwd" ];
    services = [ "btrbk" ];
    hardware = [ "yubikey" ];
  };

  attrsToImports = input:
    lib.lists.flatten
      (lib.attrsets.mapAttrsToList
        (dir: map (f: ./../.. + "/${dir}/${f}.nix")) 
      input);
in
{

  imports = attrsToImports nixrc;

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

    # Add exfat support
    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    supportedFilesystems = [ "zfs" ]; 

    zfs.enableUnstable = true;
  };

  services.mbpfan.enable = true;

  networking.hostId = "c1093b49";

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  networking.resolvconf.dnsExtensionMechanism = false;

  system.stateVersion = "20.03";
}
