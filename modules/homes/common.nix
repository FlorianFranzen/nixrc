# Base config for all homes
{ lib, ... }:

{
  programs.home-manager.enable = true;

  home = {
    extraOutputsToInstall = [ "doc" ];

    stateVersion = lib.mkDefault "21.11";
  };
}
