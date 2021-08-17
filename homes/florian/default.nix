{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./fonts.nix
    ./themes.nix
    ./sway.nix
    ./i3status.nix
    ./mako.nix
    ./spacemacs.nix
  ];

  programs.home-manager.enable = true;
}
