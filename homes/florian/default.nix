{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./sway.nix
    ./spacemacs.nix
  ];

  programs.home-manager.enable = true;
}
