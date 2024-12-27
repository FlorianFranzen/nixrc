{ lib, pkgs, ... }:

{
  # Use secure boot integration
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
