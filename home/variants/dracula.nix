# Dracula with the official Alucard light variant (draculatheme.com/spec)
{ pkgs, static, ... }:

{
  theme = {
    enable = true;
    name = "dracula";

    palette.dark = {
      background = "#282a36";
      foreground = "#f8f8f2";
      selectionBg = "#44475a";

      black = "#21222c";
      red = "#ff5555";
      green = "#50fa7b";
      yellow = "#f1fa8c";
      blue = "#bd93f9";
      magenta = "#ff79c6";
      cyan = "#8be9fd";
      white = "#f8f8f2";

      brightBlack = "#6272a4";
      brightRed = "#ff6e6e";
      brightGreen = "#69ff94";
      brightYellow = "#ffffa5";
      brightBlue = "#d6acff";
      brightMagenta = "#ff92df";
      brightCyan = "#a4ffff";
      brightWhite = "#ffffff";

      accent = "#bd93f9";
      secondary = "#ff79c6";
      tertiary = "#8be9fd";
      surfaceVariant = "#44475a";
      foregroundDim = "#6272a4";
      outline = "#6272a4";
    };

    palette.light = {
      background = "#fffbeb";
      foreground = "#1f1f1f";
      selectionBg = "#cfcfde";

      black = "#fffbeb";
      red = "#cb3a2a";
      green = "#14710a";
      yellow = "#846e15";
      blue = "#644ac9";
      magenta = "#a3144d";
      cyan = "#036a96";
      white = "#1f1f1f";

      brightBlack = "#6c664b";
      brightRed = "#d74c3d";
      brightGreen = "#198d0c";
      brightYellow = "#9e841a";
      brightBlue = "#7862d0";
      brightMagenta = "#bf185a";
      brightCyan = "#047fb4";
      brightWhite = "#2c2b31";

      accent = "#644ac9";
      secondary = "#a3144d";
      tertiary = "#036a96";
      surfaceVariant = "#cfcfde";
      foregroundDim = "#6c664b";
      outline = "#6c664b";
    };

    wallpaper.dark = static.wallpapers.mojave-dark;

    gtk = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Nordzy-orange-dark";
      package = pkgs.nordzy-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
    };

    bat = "Dracula";
    i3status = "dracula";
  };
}
