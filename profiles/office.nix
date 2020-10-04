{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zathura
    evince
    pandoc
    pdftk
    texlive.combined.scheme-full
    tectonic

    libreoffice-fresh
    zotero
    gimp
#    gimp-with-plugins
    inkscape
    gnucash
   ];
 }

