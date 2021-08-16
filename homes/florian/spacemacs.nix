{ config, pkgs, sources, ... }:

{
  home.file.".emacs.d" = {
    source = sources.spacemacs;
    recursive = true;
  };
  home.file.".spacemacs".source = ./spacemacs.el;
}
