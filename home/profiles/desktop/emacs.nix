{ pkgs, ... }:

{
  # Special wayland friendly version
  programs.doom-emacs.emacs = pkgs.emacs-pgtk;
}

