{ pkgs, ... }:

{
  xdg.portal = {
    # Install gtk, hypland and wlr portals
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
    ];
    # Use gtk for all but screensharing
    config.hyprland.default = [ "hyprland" "gtk" ];
    config.sway.default = [ "wlr" "gtk" ];
  };
}
