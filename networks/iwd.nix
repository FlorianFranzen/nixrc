{ config, pkgs, lib, ... }:

{ 
  # Enable dynamic configured iwd
  networking.wireless.iwd.enable = true;

  # Reenable renaming interfaces
  systemd.network.links."80-iwd" = lib.mkForce {};
}


