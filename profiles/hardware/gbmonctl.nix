{ pkgs, ... }:

{
  # Install additional tooling
  environment.systemPackages = [ pkgs.gbmonctl ]; 

  services.udev.extraRules = ''
    # Provide access to gigabyte display
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="1100", TAG+="uaccess"
  '';
}
