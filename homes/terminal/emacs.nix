{ pkgs, lib, ... }:

{
  # Install various dependencies
  home.packages = with pkgs; [
    editorconfig-core-c
    emacs-all-the-icons-fonts
  ];

  # Setups managed doom-emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = ../../emacs;

    emacs = lib.mkDefault pkgs.emacs-nox;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
}
