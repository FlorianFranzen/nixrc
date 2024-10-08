{ pkgs, assets, ... }:

{
  # Theme pywal and integrations
  pywal.theme = "base16-dracula";
  pywal.background = assets.wallpaper-mojave-dark;

  # Set cursor theme
  wayland.windowManager.sway.config.seat."*" = {
    xcursor_theme = "Bibata-Original-Ice";
  };

  # Theme command line tools
  programs.bat.config.theme = "Dracula";

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "dracula";
  programs.i3status-rust.bars.bottom.theme = "dracula";

  # Set gtk look and feel
  gtk = {
    theme = {
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
  };
}
