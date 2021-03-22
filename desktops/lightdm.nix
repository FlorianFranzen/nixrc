{ config, pkgs, ... }:

{
  # Enable LightDM display manager
  services.xserver = {
    enable = true; # TODO: Switch to non-X11 greeter
    displayManager.lightdm.enable = true;
  };
}
