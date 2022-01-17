channels: 

final: prev: 

let
  # Unstable packages we can use to override dependencies
  inherit (channels.unstable) libdrm mesa pipewire wayland xwayland;

  # wlroots needs newer libdrm (incl in mesa and xwayland)
  wlroots = prev.wlroots.override {
    inherit libdrm mesa xwayland;
  };
in {

  # Do not reexport packages from unstable 
  __dontExport = true; # overrides clutter up actual creations
  
  # Unstable packages we can use right away
  inherit (channels.unstable) wofi;

  # Do not use broken wayland support for now
  element-desktop-wayland = channels.unstable.element-desktop;

  # Latest desktop portal needs newer pipewire
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.override {
    inherit pipewire;
  };
 
  # Latest sway depends on broken wlroots
  sway-unwrapped = prev.sway-unwrapped.override {
    inherit wlroots;
  };
}
