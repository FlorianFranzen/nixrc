{ pkgs, assets, ...}:

{
  # Theme pywal and integrations
  pywal.theme = "base16-spacemacs";
  pywal.background = assets.wallpaper-nixish-dark;

  # Set cursor theme
  wayland.windowManager.sway.config.seat."*" = {
    xcursor_theme = "Numix-Cursor";
  };

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
