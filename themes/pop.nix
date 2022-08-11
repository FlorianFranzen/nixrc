{ self, pkgs, ...}:

{
  imports = [ ./base.nix ];

  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Pop";
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
