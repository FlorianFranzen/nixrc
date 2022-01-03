{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.pywal;

  mkWalCache = theme: pkgs.runCommand "wal-cache-${theme}" {} ''
    export HOME=$(mktemp -d)

    ${pkgs.pywal}/bin/wal --theme ${theme} -enst

    mv $HOME/.cache/wal $out
  '';

  cache = mkWalCache cfg.theme;
in {

  options.pywal = {
    enable = mkEnableOption "pywal theme manager";

    theme = mkOption {
      type = types.str;
      default = "random"; # TODO *cough*
    };
  };

  config = mkIf cfg.enable {
    home.file.".cache/wal".source = cache;

    programs.zsh.initExtra = ''
      # Load color scheme
      (cat ${cache}/sequences &)
    '';
  };
}
