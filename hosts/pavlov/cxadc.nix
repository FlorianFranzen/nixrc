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
  environment.systemPackages = with pkgs; [
    kernelPkgs.cxadc
    ffmpeg-headless
    flac
    pv
    sox
  ];

  # Enable alsa integration for clockgen mod
  hardware.alsa.enable = true;

  services.udev = {
    # Load included udev config
    packages = [ kernelPkgs.cxadc ];

    # Extend udev config for clockgen mod
    extraRules = ''
      # Initialize cxadc0 with correct vmux, crystal, center, level and gain
      KERNEL=="cxadc0", SUBSYSTEM=="cxadc", ATTR{device/parameters/vmux}="1"
      KERNEL=="cxadc0", SUBSYSTEM=="cxadc", ATTR{device/parameters/crystal}="40000000"
      KERNEL=="cxadc0", SUBSYSTEM=="cxadc", ATTR{device/parameters/center_offset}="1"
      KERNEL=="cxadc0", SUBSYSTEM=="cxadc", ATTR{device/parameters/level}="0"
      KERNEL=="cxadc0", SUBSYSTEM=="cxadc", ATTR{device/parameters/sixdb}="0"

      # Initialize cxadc1 with correct vmux, crystal, center, level and gain
      KERNEL=="cxadc1", SUBSYSTEM=="cxadc", ATTR{device/parameters/vmux}="1"
      KERNEL=="cxadc1", SUBSYSTEM=="cxadc", ATTR{device/parameters/crystal}="40000000"
      KERNEL=="cxadc1", SUBSYSTEM=="cxadc", ATTR{device/parameters/center_offset}="1"
      KERNEL=="cxadc1", SUBSYSTEM=="cxadc", ATTR{device/parameters/level}="0"
      KERNEL=="cxadc1", SUBSYSTEM=="cxadc", ATTR{device/parameters/sixdb}="0"
    '';
  };

  # Allow rootless access for default user
  users.extraUsers.${username}.extraGroups = [ "audio" "video" ];
}
