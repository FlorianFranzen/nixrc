{ pkgs, assets, ...}:

{
  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Numix-Cursor";
    };

    # Set desktop background
    output."*" = {
      background = "${assets.wallpaper-snowflake-solarized} fill";
    };
  };

  pywal.theme = "solarized";

  # Theme command line tools
  programs.bat.config.theme = "Solarized (dark)";
  programs.broot.settings.syntax_theme = "SolarizedDark";
  programs.broot.settings.imports = [ "skins/solarized-dark.hjson" ];

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "solarized-dark";
  programs.i3status-rust.bars.bottom.theme = "solarized-dark";

  # Set gtk look and feel
  gtk = {

    theme = {
      name = "NumixSolarizedDarkGreen";
      package = pkgs.numix-solarized-gtk-theme;
    };

    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
  };
}
