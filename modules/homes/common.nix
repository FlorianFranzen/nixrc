# Base config for all homes
{ lib, ... }:

{
  programs.home-manager.enable = true;

  home = {
    extraOutputsToInstall = [ "doc" ];

    # Force needed to override default set in homeManagerConfiguration
    stateVersion = lib.mkForce "22.11";
  };
}
