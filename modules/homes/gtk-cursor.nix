{ config, lib, pkgs, ...}:

# TODO Upstream this module/option

with lib;

let
  cfg = config.gtk.cursorTheme;

  cursorThemeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.numix-cursor-theme";
        description = ''
          Package providing the theme. This package will be installed
          to your profile. If <literal>null</literal> then the theme
          is assumed to already be available in your profile.
        '';
      };

      name = mkOption {
        type = types.str;
        example = "Numix-Cursor";
        description = "The name of the theme within the package.";
      };

      size = mkOption {
        type = types.int;
        default = 0;
        description = "The size of the cursor, zero means use default.";
      };
    };
  };
in {
  options.gtk.cursorTheme = mkOption {
    type = types.nullOr cursorThemeType;
    default = null;
    description = "The cursor theme to use.";
  };

  config = mkIf (cfg != null) {

    gtk.gtk2.extraConfig = ''
      gtk-cursor-theme-name="${cfg.name}"
      gtk-cursor-theme-size=${toString cfg.size}
    '';

    gtk.gtk3.extraConfig = {
      "gtk-cursor-theme-name" = cfg.name;
      "gtk-cursor-theme-size" = cfg.size;
    };

    home.packages = mkIf (cfg.package != null) [ cfg.package ];
  };
}
