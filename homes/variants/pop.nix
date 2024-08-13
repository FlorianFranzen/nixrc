{ pkgs, assets, ...}:

{
  # Theme pywal and integrations
  pywal.theme = "pop";
  pywal.background = assets.wallpaper-mojave-dark};

  # Set cursor theme
  wayland.windowManager.sway.config.seat."*" = {
    xcursor_theme = "Pop";
  };

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "dracula";
  programs.i3status-rust.bars.bottom.theme = "dracula";

  # Set gtk look and feel
  gtk = {
    theme = {
      name = "Pop-dark";
      package = pkgs.pop-gtk-theme;
    };

    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };

    cursorTheme = {
      name = "Pop";
    };
  };
}
