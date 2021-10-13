{ inputs, config, pkgs, ... }:

{
  home.file.".emacs.d" = {
    source = inputs.spacemacs;
    recursive = true;
  };
  home.file.".spacemacs".source = ./spacemacs.el;
}
