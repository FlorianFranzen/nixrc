{ pkgs, ...}:

{
  # Set gtk look and feel
  gtk = {
    enable = true;

    #TODO: Set cursor theme?

    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };

  # Use gtk theme for qt
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
