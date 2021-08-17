{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./sway.nix
    ./mako.nix
    ./spacemacs.nix
  ];

  programs.home-manager.enable = true;
}
