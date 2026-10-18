{ pkgs, static, ... }:

{
  theme = {
    enable = true;
    name = "gruvbox";

    noctalia.source = "builtin";
    noctalia.builtin = "Gruvbox";

    # Medium contrast dark / light from the original vim scheme
    palette.dark = {
      background = "#282828";
      foreground = "#ebdbb2";

      black = "#282828";
      red = "#cc241d";
      green = "#98971a";
      yellow = "#d79921";
      blue = "#458588";
      magenta = "#b16286";
      cyan = "#689d6a";
      white = "#a89984";

      brightBlack = "#928374";
      brightRed = "#fb4934";
      brightGreen = "#b8bb26";
      brightYellow = "#fabd2f";
      brightBlue = "#83a598";
      brightMagenta = "#d3869b";
      brightCyan = "#8ec07c";
      brightWhite = "#ebdbb2";

      accent = "#fe8019";
      secondary = "#8ec07c";
      tertiary = "#d3869b";
      surfaceVariant = "#3c3836";
      foregroundDim = "#a89984";
      outline = "#665c54";
    };

    palette.light = {
      background = "#fbf1c7";
      foreground = "#3c3836";

      black = "#fbf1c7";
      red = "#cc241d";
      green = "#98971a";
      yellow = "#d79921";
      blue = "#458588";
      magenta = "#b16286";
      cyan = "#689d6a";
      white = "#7c6f64";

      brightBlack = "#928374";
      brightRed = "#9d0006";
      brightGreen = "#79740e";
      brightYellow = "#b57614";
      brightBlue = "#076678";
      brightMagenta = "#8f3f71";
      brightCyan = "#427b58";
      brightWhite = "#3c3836";

      accent = "#af3a03";
      secondary = "#427b58";
      tertiary = "#8f3f71";
      surfaceVariant = "#ebdbb2";
      foregroundDim = "#7c6f64";
      outline = "#bdae93";
    };

    wallpaper.dark = static.wallpapers.astronaut-gruvbox;

    gtk = {
      name = "gruvbox-dark-gtk";
      package = pkgs.gruvbox-dark-gtk;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    cursorTheme = {
      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;
    };

    bat = "gruvbox-dark";
    broot = "skins/dark-gruvbox.hjson";
    i3status = "gruvbox-dark";

    plasma = {
      packages = [ pkgs.kde-gruvbox ];
      workspace = {
        colorScheme = "Gruvbox";
        iconTheme = "Gruvbox-Plus-Dark";
        theme = "breeze-dark";
        wallpaper = "${static.wallpapers.astronaut-gruvbox}";
      };
    };
  };
}
