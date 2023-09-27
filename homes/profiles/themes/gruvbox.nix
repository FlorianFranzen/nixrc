{ pkgs, ...}:

{
  imports = [ ./base.nix ];

  wayland.windowManager.sway.config ={
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Capitainei\\ Cursors\\ (Gruvbox)\\ -\\ White";
    };

    # Set desktop background
    output."*" = {
      background = "${./assets/astronaut-gruvbox.jpg} fill";
    };
  };

  pywal.theme = "gruvbox";

  # Theme command line tools
  programs.bat.config.theme = "gruvbox-dark";
  programs.broot.settings.imports = [ "skins/dark-gruvbox.hjson" ];

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "gruvbox-dark";
  programs.i3status-rust.bars.bottom.theme = "gruvbox-dark";

  # Set gtk look and feel
  gtk = {

    theme = {
      name = "Gruvbox-Dark-B";
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    cursorTheme = {
      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;
    };
  };
}
