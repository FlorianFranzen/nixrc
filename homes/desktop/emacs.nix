{ pkgs, ... }:

{
  # Special wayland friendly version
  programs.emacs.package = pkgs.emacs29-pgtk;
}

