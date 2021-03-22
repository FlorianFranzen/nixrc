{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "eu";
    xkbOptions = "compose:ralt, terminate:ctrl_alt_bksp";
 
    # Enable touchpad support through libinput
    libinput = {
      enable = true;
      disableWhileTyping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      tapping = false;
      tappingDragLock = false;
    };

    # Use xfce base services
    desktopManager = {
      xterm.enable = false;
#      xfce = {
#        enable = true;
#        noDesktop = true;
#        enableXfwm = false;
#      };
    };

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
        arandr
      ];
    };
  };

 # Enable compton
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
#    opacityRules = [
#      "95:class_g = 'Termite' && !_NET_WM_STATE@:32a" 
#      "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
#    ];
  };
 
}
