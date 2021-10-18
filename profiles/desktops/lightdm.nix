{ config, pkgs, ... }:

{
  # Enable LightDM display manager
  services.xserver = {
    # TODO: Switch to non-X11 greeter
    enable = true;

    # Add trackpad support
    libinput = {
      enable = true;
      touchpad.tapping = false;
    };

    # Enable greeter itself
    displayManager.lightdm.enable = true;
  };
}
