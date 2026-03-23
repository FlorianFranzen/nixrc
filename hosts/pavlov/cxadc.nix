{ config, pkgs, username, ... }:

let
  kernelPkgs = config.boot.kernelPackages;
in {
  boot = {
    # Install needed kernel module
    extraModulePackages = [ kernelPkgs.cxadc ];

    # Ensure kernel module is loaded
    kernelModules = [ "cxadc" ];
  };
  
  # Load included modprobe config
  environment.etc."modprobe.d/cxadc.conf".source = "${kernelPkgs.cxadc}/lib/modprobe.d/cxadc.conf";

  # Install included cli tools and other needed packages
  environment.systemPackages = [
    kernelPkgs.cxadc
    pkgs.flac
  ];

  # Load included udev config
  services.udev.packages = [ kernelPkgs.cxadc ];

  # Allow rootless access for default user
  users.extraUsers.${username}.extraGroups = [ "video" ];
}
