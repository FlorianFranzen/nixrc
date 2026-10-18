# Solarized with the contrast fixed (github.com/jan-warchol/selenized)
{ pkgs, static, ... }:

{
  theme = {
    enable = true;
    name = "selenized";

    palette.dark = {
      background = "#103c48";
      foreground = "#adbcbc";

      black = "#184956";
      red = "#fa5750";
      green = "#75b938";
      yellow = "#dbb32d";
      blue = "#4695f7";
      magenta = "#f275be";
      cyan = "#41c7b9";
      white = "#72898f";

      brightBlack = "#2d5b69";
      brightRed = "#ff665c";
      brightGreen = "#84c747";
      brightYellow = "#ebc13d";
      brightBlue = "#58a3ff";
      brightMagenta = "#ff84cd";
      brightCyan = "#53d6c7";
      brightWhite = "#cad8d9";

      accent = "#4695f7";
      secondary = "#ed8649";
      tertiary = "#af88eb";
      surfaceVariant = "#184956";
      foregroundDim = "#72898f";
      outline = "#2d5b69";
    };

    palette.light = {
      background = "#fbf3db";
      foreground = "#53676d";

      black = "#ece3cc";
      red = "#d2212d";
      green = "#489100";
      yellow = "#ad8900";
      blue = "#0072d4";
      magenta = "#ca4898";
      cyan = "#009c8f";
      white = "#909995";

      brightBlack = "#d5cdb6";
      brightRed = "#cc1729";
      brightGreen = "#428b00";
      brightYellow = "#a78300";
      brightBlue = "#006dce";
      brightMagenta = "#c44392";
      brightCyan = "#00978a";
      brightWhite = "#3a4d53";

      accent = "#0072d4";
      secondary = "#c25d1e";
      tertiary = "#8762c6";
      surfaceVariant = "#ece3cc";
      foregroundDim = "#909995";
      outline = "#d5cdb6";
    };

    wallpaper.dark = static.wallpapers.snowflake-solarized;

    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    bat = "Solarized (dark)";
    broot = "skins/solarized-dark.hjson";
    i3status = "solarized-dark";
  };
}
