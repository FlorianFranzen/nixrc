{ pkgs, assets, ...}:

{
  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Pop";
    };

    # Set desktop background
    output."*" = {
      background = "${assets.wallpaper-mojave-dark} fill";
    };
  };

  pywal.theme = "pop";

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
