{ pkgs, ... }:

let 
  theme = "base16-spacemacs";            

  output = pkgs.runCommand "wal-${theme}" {} ''
    export HOME=$(mktemp -d)

    ${pkgs.pywal}/bin/wal --theme ${theme} -enst

    mkdir -p $out/share

    mv $HOME/.cache/wal $out/share
  '';
in {
  home.file.".cache/wal".source = "${output}/share/wal";
}
