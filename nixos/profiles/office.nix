{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zathura
    evince
    pandoc
    pdftk
    tectonic
    texlab

    (aspellWithDicts (d: [ d.en d.de d.es d.fr ]))

    libreoffice-fresh
    zotero
    gimp
    inkscape
    ledger
    (calibre.override { speechSupport = false; })
   ];

  environment.etc."aspell.conf".text = ''
    master en_US
  '';
}
