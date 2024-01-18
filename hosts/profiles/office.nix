{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zathura
    evince
    pandoc
    pdftk
    texlive.combined.scheme-full
    tectonic
    texmacs

    (aspellWithDicts (d: [ d.en d.en-computers d.en-science d.de d.es d.fr ]))

    libreoffice-fresh
    zotero
    gimp
    inkscape
    ledger
    calibre
   ];

  environment.etc."aspell.conf".text = ''
    master en_US
    extra-dicts en-computers.rws
    extra-dicts en_US-science.rws
  '';
}

