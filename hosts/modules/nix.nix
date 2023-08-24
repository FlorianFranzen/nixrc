# Base nix config for all hosts
{ config, lib, pkgs, ... }:

{
  nix = {
    # Use same nix version on all hosts
    package = pkgs.hydra-unstable.nix;

    # Enable flake support
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Allow copy closure by admins
    settings.trusted-users = [ "root" "@wheel" ];
  };
}	
