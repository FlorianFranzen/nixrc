{ pkgs, ... }:

{
  # Install gbmonctl command line and udev rules
  environment.systemPackages = [ pkgs.gbmonctl ]; 
  services.udev.packages = [ pkgs.gbmonctl ];
}
