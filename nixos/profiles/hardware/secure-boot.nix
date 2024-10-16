{ lib, pkgs, ... }:

{
  # Use secure boot integration
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
