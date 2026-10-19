# Theme data shared by every stack. Variants (home/variants) set the data,
# the stack profiles (terminal, desktop, sway, kde, noctalia) apply it.
{ config, lib, ... }:

with lib;

let
  cfg = config.theme;

  hex = types.strMatching "#[0-9a-fA-F]{6}";

  # One mode of a palette: terminal colours plus a few shell roles
  palette = types.submodule ({ config, ... }: {
    options = {
      background = mkOption { type = hex; };
      foreground = mkOption { type = hex; };

      cursor = mkOption { type = hex; default = config.foreground; };
      cursorText = mkOption { type = hex; default = config.background; };
      selectionBg = mkOption { type = hex; default = config.surfaceVariant; };
      selectionFg = mkOption { type = hex; default = config.foreground; };

      black = mkOption { type = hex; };
      red = mkOption { type = hex; };
      green = mkOption { type = hex; };
      yellow = mkOption { type = hex; };
      blue = mkOption { type = hex; };
      magenta = mkOption { type = hex; };
      cyan = mkOption { type = hex; };
      white = mkOption { type = hex; };

      brightBlack = mkOption { type = hex; };
      brightRed = mkOption { type = hex; };
      brightGreen = mkOption { type = hex; };
      brightYellow = mkOption { type = hex; };
      brightBlue = mkOption { type = hex; };
      brightMagenta = mkOption { type = hex; };
      brightCyan = mkOption { type = hex; };
      brightWhite = mkOption { type = hex; };

      # Shell roles (Material names in noctalia)
      accent = mkOption { type = hex; description = "Primary accent, also the host colour."; };
      secondary = mkOption { type = hex; default = config.blue; };
      tertiary = mkOption { type = hex; default = config.magenta; };
      surfaceVariant = mkOption { type = hex; default = config.black; description = "Cards, panels."; };
      foregroundDim = mkOption { type = hex; default = config.brightBlack; description = "Secondary text."; };
      outline = mkOption { type = hex; default = config.brightBlack; };
    };
  });

  # A theme component with a name and an optional package
  named = types.nullOr (types.submodule {
    options = {
      name = mkOption { type = types.str; };
      package = mkOption { type = types.nullOr types.package; default = null; };
    };
  });

  esc = builtins.fromJSON ''"\u001b"'';
  osc = n: value: "${esc}]${n};${value}${esc}\\";

  ansi = p: with p; [
    black red green yellow blue magenta cyan white
    brightBlack brightRed brightGreen brightYellow brightBlue brightMagenta brightCyan brightWhite
  ];

  # OSC 4/10/11/12/17/19: recolour a running terminal
  toSequences = p: concatStrings (
    imap0 (i: c: osc "4" "${toString i};${c}") (ansi p)
    ++ [
      (osc "10" p.foreground)
      (osc "11" p.background)
      (osc "12" p.cursor)
      (osc "17" p.selectionBg)
      (osc "19" p.selectionFg)
    ]
  );

  # Noctalia custom palette format (docs.noctalia.dev/noctalia/theming/palette)
  toNoctalia = p: {
    mPrimary = p.accent;
    mOnPrimary = p.background;
    mSecondary = p.secondary;
    mOnSecondary = p.background;
    mTertiary = p.tertiary;
    mOnTertiary = p.background;
    mError = p.red;
    mOnError = p.background;
    mSurface = p.background;
    mOnSurface = p.foreground;
    mSurfaceVariant = p.surfaceVariant;
    mOnSurfaceVariant = p.foregroundDim;
    mOutline = p.outline;
    mShadow = p.background;
    mHover = p.surfaceVariant;
    mOnHover = p.foreground;
    terminal = {
      inherit (p) background foreground cursor cursorText selectionBg selectionFg;
      normal = { inherit (p) black red green yellow blue magenta cyan white; };
      bright = {
        black = p.brightBlack;
        red = p.brightRed;
        green = p.brightGreen;
        yellow = p.brightYellow;
        blue = p.brightBlue;
        magenta = p.brightMagenta;
        cyan = p.brightCyan;
        white = p.brightWhite;
      };
    };
  };
in
{
  options.theme = {
    enable = mkEnableOption "theming from the selected variant";

    name = mkOption { type = types.str; description = "Variant name, e.g. gruvbox."; };

    managedBy = mkOption {
      type = types.enum [ "nix" "noctalia" ];
      default = "nix";
      description = ''
        Who writes the app theme files: nix renders them from the palette at
        build time, noctalia renders its templates at runtime (and follows
        light/dark mode).
      '';
    };

    # Builders for configs that exist both as nix output and noctalia template,
    # called with a function from palette role to colour string
    starship = mkOption {
      type = types.functionTo types.attrs;
      description = "Starship settings, given a role -> colour function.";
    };

    noctalia = {
      source = mkOption {
        type = types.enum [ "builtin" "custom" ];
        default = "custom";
        description = "Load one of noctalia's bundled palettes or the palette below.";
      };
      builtin = mkOption { type = types.str; default = cfg.name; description = "Bundled palette name."; };
      palette = mkOption {
        type = types.attrs;
        readOnly = true;
        default = { dark = toNoctalia cfg.palette.dark; light = toNoctalia cfg.palette.light; };
        description = "The palette in noctalia's custom palette format.";
      };
    };

    palette = {
      dark = mkOption { type = palette; };
      light = mkOption { type = palette; default = cfg.palette.dark; };
    };

    sequences = {
      # Builder, so a noctalia template can render the same with colour tokens
      for = mkOption { type = types.functionTo types.str; readOnly = true; default = toSequences; };
      dark = mkOption { type = types.str; readOnly = true; default = toSequences cfg.palette.dark; };
      light = mkOption { type = types.str; readOnly = true; default = toSequences cfg.palette.light; };
      reset = mkOption {
        type = types.str;
        readOnly = true;
        default = concatMapStrings (n: osc n "") [ "104" "110" "111" "112" "117" "119" ];
        description = "Restore the terminal's own colours.";
      };
    };

    wallpaper = {
      dark = mkOption { type = types.nullOr types.path; default = null; };
      light = mkOption { type = types.nullOr types.path; default = cfg.wallpaper.dark; };
    };

    # Component names used by the gtk and kde appliers
    gtk = mkOption { type = named; default = null; };
    iconTheme = mkOption { type = named; default = null; };
    cursorTheme = mkOption { type = named; default = null; };
    cursorSize = mkOption { type = types.int; default = 36; };

    # Names of third party themes for individual tools
    bat = mkOption { type = types.nullOr types.str; default = null; };
    broot = mkOption { type = types.nullOr types.str; default = null; description = "Skin import, e.g. skins/dark-gruvbox.hjson."; };
    i3status = mkOption { type = types.str; default = "plain"; };

    plasma = {
      packages = mkOption { type = types.listOf types.package; default = [ ]; };
      workspace = mkOption { type = types.attrs; default = { }; description = "Merged into programs.plasma.workspace."; };
    };

    # Enable the catppuccin home-manager module with these settings
    catppuccin = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          flavor = mkOption { type = types.str; };
          accent = mkOption { type = types.str; };
        };
      });
      default = null;
    };
  };
}
