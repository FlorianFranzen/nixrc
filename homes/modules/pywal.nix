{ pkgs, lib, config, assets, ... }:

with lib;

let
  cfg = config.pywal;

  themeArg = theme: if theme == "pop" then ./pop.json else theme;

  mkWalCache = theme: pkgs.runCommand "wal-cache-${theme}" {} ''
    export HOME=$(mktemp -d)
    ${pkgs.pywal}/bin/wal --theme ${themeArg theme} -enst
    mv $HOME/.cache/wal $out
  '';

  cache = mkWalCache cfg.theme;

  result = builtins.fromJSON (builtins.readFile "${cache}/colors.json");

  justColors = mapAttrs (_: v: lib.removePrefix "#" v) result.colors; 
in {

  options.pywal = {
    enable = mkEnableOption "pywal theme manager";

    theme = mkOption {
      type = types.str;
    };

    background = mkOption {
      type = types.path;
      default = assets.wallpaper-nixish-dark;
    };
  };

  config = mkIf cfg.enable {
    home.file.".cache/wal".source = cache;

    programs.zsh.initContent = ''
      # Load color scheme
      (cat ${cache}/sequences &)
    '';

    services.mako.settings = with result.colors; {
      background-color = "${color0}f2";
      border-color = "${color8}f2";
      progress-color = "${color6}f2";
      text-color = "${color7}f2";

      "urgency=low".border-color = "${color3}f2";

      "urgency=normal".border-color = "${color4}f2";

      "urgency=high" = {
        border-color = "${color5}f2";
        default-timeout = 0;
      };
    };

    services.wob.settings = with justColors; {
      "" = {
        border_color = "${color8}f2";
        background_color = "${color0}f2";
        bar_color = "${color6}f2";
      };
      "style.muted".bar_color = "${color8}f2";
    };

    wayland.windowManager = {
      hyprland.extraConfig = ''
        exec-once = ${pkgs.swaybg}/bin/swaybg -m fill -i ${cfg.background}
      '';

      sway.config = {
        colors = with result.colors;
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

        output."*".background = "${cfg.background} fill";
      };
    };
  };
}
