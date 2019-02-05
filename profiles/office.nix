{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     firefox
     thunderbird
     evince
     pandoc
#     texlive.combined.scheme-full
#     tectonic
     libreoffice-fresh
     zotero
     gimp-with-plugins
     inkscape
   ];
 }

