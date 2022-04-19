channels: 

final: prev: 

let
  # Unstable packages we can use to override dependencies
  inherit (channels.unstable) fcft libdrm mesa meson pipewire stdenv wayland xwayland;

  # wlroots needs newer libdrm (incl in mesa and xwayland)
  wlroots = prev.wlroots.override {
    inherit libdrm mesa xwayland;
  };
in {

  # Do not reexport packages from unstable 
  __dontExport = true; # overrides clutter up actual creations
  
  # Unstable packages we can use right away
  inherit (channels.unstable) wofi;

  # Fix newer meson builds
  foot = prev.foot.override { inherit stdenv meson fcft; };
  grim = prev.grim.override { inherit meson; };
  mako = prev.mako.override { inherit meson; };

  # Latest desktop portal needs newer pipewire
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.override {
    inherit pipewire;
  };

  # Update kernel modules. e.g. nvidia-x11
  linuxPackagesFor = channels.unstable.linuxPackagesFor;

  # Latest sway depends on broken wlroots
  sway-unwrapped = (prev.sway-unwrapped.override {
    inherit wlroots;
  });
}
