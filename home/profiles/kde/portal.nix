{ pkgs, ... }:

{
  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.kde.default = [ "kde" ];
  };
}
