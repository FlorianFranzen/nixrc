# Ink on paper, designed in Oklab (stephango.com/flexoki)
{ pkgs, static, ... }:

{
  theme = {
    enable = true;
    name = "flexoki";

    palette.dark = {
      background = "#100f0f";
      foreground = "#cecdc3";

      black = "#1c1b1a";
      red = "#af3029";
      green = "#66800b";
      yellow = "#ad8301";
      blue = "#205ea6";
      magenta = "#a02f6f";
      cyan = "#24837b";
      white = "#878580";

      brightBlack = "#575653";
      brightRed = "#d14d41";
      brightGreen = "#879a39";
      brightYellow = "#d0a215";
      brightBlue = "#4385be";
      brightMagenta = "#ce5d97";
      brightCyan = "#3aa99f";
      brightWhite = "#cecdc3";

      accent = "#4385be";
      secondary = "#da702c";
      tertiary = "#8b7ec8";
      surfaceVariant = "#282726";
      foregroundDim = "#878580";
      outline = "#403e3c";
    };

    palette.light = {
      background = "#fffcf0";
      foreground = "#100f0f";

      black = "#100f0f";
      red = "#af3029";
      green = "#66800b";
      yellow = "#ad8301";
      blue = "#205ea6";
      magenta = "#a02f6f";
      cyan = "#24837b";
      white = "#b7b5ac";

      brightBlack = "#6f6e69";
      brightRed = "#d14d41";
      brightGreen = "#879a39";
      brightYellow = "#d0a215";
      brightBlue = "#4385be";
      brightMagenta = "#ce5d97";
      brightCyan = "#3aa99f";
      brightWhite = "#cecdc3";

      accent = "#205ea6";
      secondary = "#bc5215";
      tertiary = "#5e409d";
      surfaceVariant = "#e6e4d9";
      foregroundDim = "#6f6e69";
      outline = "#dad8ce";
    };

    wallpaper.dark = static.wallpapers.nixish-dark;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
    };

    # Follows the terminal colours
    bat = "ansi";
  };
}
