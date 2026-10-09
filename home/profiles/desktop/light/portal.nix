{ pkgs, ... }:

{
  xdg.portal = {
    # Install gtk, hypland and wlr portals
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];

    # Provide consitent experience with FHS
    xdgOpenUsePortal = true;

    # Use gtk for all but screensharing
    config.hyprland.default = [ "hyprland" "gtk" ];
    config.sway.default = [ "wlr" "gtk" ];
  };
}
