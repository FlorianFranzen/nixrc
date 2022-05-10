# Base nix config for all hosts
{ config, lib, pkgs, ... }:

{
  nix = {
    # Enable flake support
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Allow copy closure by admins
    trustedUsers = [ "root" "@wheel" ];

    # Generate nix registry and path from inputs (fup)
    linkInputs = true;
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };
}	
