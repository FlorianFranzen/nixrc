# Base nix config for all hosts
{ config, lib, pkgs, ... }:

{
  nix = {
    # Enable flake support
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

    # Allow copy closure by admins
    trustedUsers = [ "root" "@wheel" ];

    # Generate nix registry and path from inputs (fup)
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };
}	
