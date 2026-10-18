{ config, lib, ... }:

let
  theme = config.theme;
in
{
  config = lib.mkIf theme.enable {
    home.packages = theme.plasma.packages;

    programs.plasma.workspace = {
      cursor = lib.mkIf (theme.cursorTheme != null) {
        size = theme.cursorSize;
        theme = theme.cursorTheme.name;
      };

      # FIXME: Needs to be packaged and installed
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__ActiveAccentFrame";
      };
    } // theme.plasma.workspace;

    programs.plasma.configFile.kdeglobals.KDE.widgetStyle = "Fusion";
  };
}
