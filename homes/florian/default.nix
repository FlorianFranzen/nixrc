{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./spacemacs.nix
  ];

  programs.home-manager.enable = true;
}
