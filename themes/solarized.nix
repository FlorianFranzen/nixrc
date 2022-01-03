{ self, pkgs, ...}:

{
  imports = [ ./base.nix ];

  # Set desktop background
  wayland.windowManager.sway.config.output."*" = {
    background = "${self}/themes/assets/snowflake-solarized.png fill";
  };

  pywal.theme = "solarized";

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
