{ self, pkgs, ...}:

{
  # Set desktop background
  wayland.windowManager.sway.config.output."*" = {
    background = "${self}/themes/assets/snowflake-solarized.png fill";
  };

  # Set gtk look and feel
  gtk = {

    # TODO Set cursor theme?

    theme = {
      name = "NumixSolarizedDarkGreen";
      package = pkgs.numix-solarized-gtk-theme;
    };

    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };
}
