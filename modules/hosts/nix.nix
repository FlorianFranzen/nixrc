# Base nix config for all hosts
{ config, lib, pkgs, ... }:

{
  nix = {
    # Use same nix version on all hosts
    package = pkgs.nixVersions.nix_2_8;

    # Enable flake support
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
