{ self, pkgs, ...}:

{
  # Set desktop background
  wayland.windowManager.sway.config.output."*" = {
    background = "${self}/themes/assets/nixish-dark.png fill";
  };

  # Set gtk look and feel
  gtk = {

    # TODO Set cursor theme?

    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };
}
