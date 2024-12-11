{ pkgs, ... }:

{
  # Special wayland friendly version
  programs.emacs.package = pkgs.emacs30-pgtk;
}

