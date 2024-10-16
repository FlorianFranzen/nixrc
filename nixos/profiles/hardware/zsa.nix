{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wally-cli ];
  services.udev.packages = [ pkgs.zsa-udev-rules ];
}
