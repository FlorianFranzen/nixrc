{ pkgs, ... }:

{
  xdg.portal = {
    # Install wlr portal for screensharing
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

    # Use gtk for all but screensharing
    config.sway.default = [ "wlr" "gtk" ];
  };
}
