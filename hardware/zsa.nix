{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wally-cli ]; 
  services.udev.packages = with pkgs; [ zsa-udev-rules ];
}
