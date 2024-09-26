{ pkgs, ... }:

{
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    config.kde.default = [ "kde" ];
  };
}
