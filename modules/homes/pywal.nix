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

  result = builtins.fromJSON (builtins.readFile "${cache}/colors.json");
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

    wayland.windowManager.sway.config.colors = with result.colors;
      let
        default = {
          background = color0;
          text = color7;
          indicator = color6;
        };
      in {
        focused = default // {
          border = color5;
          childBorder = color5;
        };
        focusedInactive = default // {
          border = color4;
          childBorder = color4;
        };
        placeholder = default // {
          border = color2;
          childBorder = color2;
        };
        unfocused = default // {
          border = color3;
          childBorder = color3;
        };
        urgent = default // {
          border = color8;
          childBorder = color8;
        };
        background = color0;
      };
  };
}
