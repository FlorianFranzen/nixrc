{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wootility ];
  services.udev.packages = [ pkgs.wooting-udev-rules ];
}
