{ pkgs, ... }:

{
  # Useful packages to work on local hardware
  environment.systemPackages = with pkgs; [
    binutils
    pciutils
    usbutils
    acpitool
    ethtool
  ];
}
