{ config, pkgs, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    layout = "eu";
    xkbOptions = "compose:ralt, terminate:ctrl_alt_bksp";

    # Enable touchpad support through libinput
    libinput = {
      enable = true;

      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
        scrollMethod = "twofinger";
        tapping = false;
        tappingDragLock = false;
      };
    };

    # Disable default desktop manager
    desktopManager.xterm.enable = false;

    # Enable i3 window manager
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock-color
        alacritty
        polybarFull
        dunst
        rofi
      ];
    };
  };

  # Enable compositor
  services.picom = {
    enable = true;
    backend = "glx";
 #   vSync = "opengl-swc";
    fade = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.9;
    menuOpacity = 0.9;
    shadow = true;
    shadowOpacity = 0.5;
    shadowOffsets = [ 0 0 ];
  };
}
