{ config, lib, ... }:

let
  theme = config.theme;

  component = c: lib.mkIf (c != null) { inherit (c) name package; };
in
{
  config = lib.mkMerge [
    {
      # Enable gtk theming by default, components come from the variant
      gtk.enable = true;

      # Avoid gtk2 rc file conflicts
      gtk.gtk2.force = true;

      # Use default gtk theme for gtk4 too
      gtk.gtk4.theme = config.gtk.theme;
    }

    (lib.mkIf theme.enable {
      gtk = {
        theme = component theme.gtk;
        iconTheme = component theme.iconTheme;
        cursorTheme = lib.mkIf (theme.cursorTheme != null) {
          inherit (theme.cursorTheme) name package;
          size = theme.cursorSize;
        };
      };

      catppuccin.firefox.force = lib.mkIf (theme.catppuccin != null) true;
    })
  ];
}
