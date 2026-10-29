{ config, options, pkgs, lib, ... }:

let
  theme = config.theme;

  # Palette roles as noctalia template tokens
  tokens = lib.mapAttrs (_: t: "{{ colors.${t}.default.hex }}") {
    background = "terminal_background";
    foreground = "terminal_foreground";
    cursor = "terminal_cursor";
    cursorText = "terminal_cursor_text";
    selectionBg = "terminal_selection_bg";
    selectionFg = "terminal_selection_fg";
    black = "terminal_normal_black";
    red = "terminal_normal_red";
    green = "terminal_normal_green";
    yellow = "terminal_normal_yellow";
    blue = "terminal_normal_blue";
    magenta = "terminal_normal_magenta";
    cyan = "terminal_normal_cyan";
    white = "terminal_normal_white";
    brightBlack = "terminal_bright_black";
    brightRed = "terminal_bright_red";
    brightGreen = "terminal_bright_green";
    brightYellow = "terminal_bright_yellow";
    brightBlue = "terminal_bright_blue";
    brightMagenta = "terminal_bright_magenta";
    brightCyan = "terminal_bright_cyan";
    brightWhite = "terminal_bright_white";
    accent = "primary";
    secondary = "secondary";
    tertiary = "tertiary";
    surfaceVariant = "surface_variant";
    foregroundDim = "on_surface_variant";
    outline = "outline";
  };

  toml = pkgs.formats.toml { };

  # Templates noctalia renders; their outputs must stay writable
  templates = {
    starship = {
      source = toml.generate "starship-template.toml" (theme.starship (role: tokens.${role}));
      output = "$XDG_CONFIG_HOME/starship/starship.toml";
    };
    sequences = {
      text = theme.sequences.for tokens;
      output = "$XDG_CONFIG_HOME/zsh/sequences";
    };
    # Noctalia's own umbriel template, taken from the package so it follows
    # umbriel's config keys, but run as a user template (no hook editing
    # the read-only config.toml)
    umbriel = {
      source = "${config.programs.noctalia.package}/share/noctalia/assets/templates/umbriel/umbriel.toml";
      output = "$XDG_CONFIG_HOME/umbriel/noctalia.toml";
    };
  };

  # Disable catppuccin's modules for apps that noctalia themes
  hasEnable = path: lib.hasAttrByPath (path ++ [ "enable" ]) options.catppuccin;
  catppuccinOff = lib.foldl lib.recursiveUpdate { } (map
    (path: lib.setAttrByPath (path ++ [ "enable" ]) (lib.mkForce false))
    (lib.filter hasEnable [ [ "ghostty" ] [ "gtk" "icon" ] [ "kvantum" ] [ "qt5ct" ] [ "starship" ] ]));
in
{
  config = lib.mkIf theme.enable {
    theme.managedBy = "noctalia";

    programs.noctalia = {
      settings.theme = {
        source = theme.noctalia.source;

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [ "ghostty" "gtk3" "gtk4" "qt" "emacs" ];

          user = lib.mapAttrs (name: t: {
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/${name}";
            output_path = t.output;
          } // (t.extra or { })) templates;
        };
      } // (
        if theme.noctalia.source == "builtin"
        then { builtin = theme.noctalia.builtin; }
        else { custom_palette = theme.name; }
      );

      customPalettes = lib.mkIf (theme.noctalia.source == "custom") {
        ${theme.name} = theme.noctalia.palette;
      };
    };

    xdg.configFile = lib.mapAttrs' (name: t: lib.nameValuePair "noctalia/templates/${name}" (
      if t ? source then { inherit (t) source; } else { inherit (t) text; }
    )) templates // {
      # Replace a gtk.css the noctalia hook may have written in place
      "gtk-3.0/gtk.css".force = true;
      "gtk-4.0/gtk.css".force = true;

      # qt6ct picks up the colours rendered by the qt template
      "qt6ct/qt6ct.conf".text = ''
        [Appearance]
        custom_palette=true
        color_scheme_path=${config.xdg.configHome}/qt6ct/colors/noctalia.conf
        style=Fusion
      '';
    };

    # Starship reads the rendered file instead of a nix generated one
    programs.starship.configPath = "${config.xdg.configHome}/starship/starship.toml";

    # Gtk follows the colour scheme preference noctalia sets. Its gtk
    # templates render noctalia.css next to gtk.css and expect an import in
    # gtk.css; ship the import ourselves so the hook never edits the file,
    # and force the file so a hook-written copy cannot block activation.
    theme.gtk = lib.mkForce {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk.gtk3.extraCss = ''@import url("noctalia.css");'';
    gtk.gtk4.extraCss = ''@import url("noctalia.css");'';

    qt.platformTheme.name = lib.mkForce "qtct";
    qt.style.name = lib.mkForce "fusion";

    catppuccin = catppuccinOff;
  };
}
