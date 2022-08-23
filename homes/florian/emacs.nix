{ config, pkgs, inputs, self, ... }:

let
  emacsPkgs = inputs.emacs-overlay.packages.${pkgs.system};
in {
  # Install various dependencies
  home.packages = with pkgs; [ 
    editorconfig-core-c
  ];

  # Enable doom framework
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = "${self}/emacs";

    emacsPackage = emacsPkgs.emacsPgtkNativeComp;
  };

  # Enable emacs server
  services.emacs.enable = true;
}



