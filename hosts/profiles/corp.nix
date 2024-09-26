{ config, pkgs, ... }:

{
  # Support virtual cameras
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  environment.systemPackages = with pkgs; [
    obs-studio

    slack
    zoom-us
  ];

}

