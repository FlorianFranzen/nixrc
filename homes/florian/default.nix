{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./fonts.nix
    ./themes.nix
    ./sway.nix
    ./swaylock.nix
    ./i3status.nix
    ./wofi.nix
    ./mako.nix
    ./spacemacs.nix
  ];

  programs.home-manager.enable = true;
}
