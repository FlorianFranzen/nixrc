channels: 

final: prev: 

let
  # Unstable packages we can use to override dependencies
  inherit (channels.unstable) libdrm mesa meson pipewire wayland xwayland;

  # wlroots needs newer libdrm (incl in mesa and xwayland)
  wlroots = prev.wlroots.override {
    inherit libdrm mesa xwayland;
  };
in {

  # Do not reexport packages from unstable 
  __dontExport = true; # overrides clutter up actual creations
  
  # Unstable packages we can use right away
  inherit (channels.unstable) wofi;

  # Fix newer sway builds
  grim = prev.grim.override { inherit meson; };

  # Latest desktop portal needs newer pipewire
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.override {
    inherit pipewire;
  };

  i3status-rust = prev.i3status-rust.overrideAttrs (old: {
    cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
      outputHash = "VJYeG7TBFy1+JDFjmb1TuSFgNavi2Ap7/jiYsll0f78=";
    }); 
  });

  # Latest sway depends on broken wlroots
  sway-unwrapped = (prev.sway-unwrapped.override {
    inherit wlroots;
  });
}
