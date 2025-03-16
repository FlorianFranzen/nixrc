{ pkgs, ... }:

{
  # Special wayland friendly version
  programs.emacs.package = pkgs.emacs-pgtk;
}

