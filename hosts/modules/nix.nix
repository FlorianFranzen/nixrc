# Base nix config for all hosts
{ config, lib, pkgs, ... }:

{
  nix = {
    # Disable channels
    channel.enable = false;

    # Enable flake support
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Use same nix version on all hosts
    package = pkgs.hydra-unstable.nix;

    # Allow copy closure by admins
    settings.trusted-users = [ "root" "@wheel" ];
  };
}
