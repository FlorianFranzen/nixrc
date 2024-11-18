{ pkgs, ... }:

{
  # Use full plasma integrated version of syncthingtray
  services.syncthing.tray.package = pkgs.syncthingtray;
}

