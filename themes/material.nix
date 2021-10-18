{ self, pkgs, ...}:

{
  imports = [ ./base.nix ];

  # Set desktop background
  wayland.windowManager.sway.config.output."*" = {
    background = "${self}/themes/assets/nixish-dark.png fill";
  };

  # Set gtk look and feel
  gtk = {

    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
  };
}
