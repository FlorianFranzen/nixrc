{ pkgs, ... }:

{
  # Special wayland friendly version
  programs.emacs.package = pkgs.emacs29-pgtk;

  # Use same package for server
  services.emacs.package = pkgs.emacs29-pgtk;
}

