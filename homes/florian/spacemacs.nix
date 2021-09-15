{ config, pkgs, srcs, ... }:

{
  home.file.".emacs.d" = {
    source = srcs.spacemacs;
    recursive = true;
  };
  home.file.".spacemacs".source = ./spacemacs.el;
}
