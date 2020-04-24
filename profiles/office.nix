{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     zathura
     evince
     pandoc
     texlive.combined.scheme-full
     tectonic

     libreoffice-fresh
     zotero
     gimp-with-plugins
     inkscape
     gnucash
   ];
 }

