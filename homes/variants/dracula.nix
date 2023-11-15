{ pkgs, assets, ... }:

{
  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Bibata-Original-Ice";
    };

    # Set desktop background
    output."*" = {
      background = "${assets.wallpaper-mojave-dark} fill";
    };
  };

  pywal.theme = "base16-dracula";

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
