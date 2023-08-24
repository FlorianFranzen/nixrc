{ self, pkgs, ...}:

{
  imports = [ ./base.nix ];

  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Numix-Cursor";
    };

    # Set desktop background
    output."*" = {
      background = "${self}/themes/assets/nixish-dark.png fill";
    };
  };

  pywal.theme = "base16-spacemacs";

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "modern";
  programs.i3status-rust.bars.bottom.theme = "modern";

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
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
    };
  };
}
