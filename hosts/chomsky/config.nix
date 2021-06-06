{ config, pkgs, lib,  ... }:

let
  nixrc = {
    profiles = [ "full" "docker" "gaming" ];
    develop  = [ "default" "emacs" "extra" "manufac" ];
    desktops = [ "lightdm" "sway" ];
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
      "i915.modeset=1"
      "i915.enable_fbc=1"
#      "usbcore.autosupend=1h"
      "i915.lvds_channel_mode=2"
    ];

    extraModprobeConfig = ''
      options sdhci debug_quirks2=4
      options snd-intel-dspcfg dsp_driver=1
    '';

    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      enableCryptodisk = true; 
      efiInstallAsRemovable = true;
    };

  };

  services.mbpfan.enable = true;

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  networking.resolvconf.dnsExtensionMechanism = false;

  system.stateVersion = "20.03";
}
