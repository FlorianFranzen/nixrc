{ pkgs, assets, ...}:

{
  # Theme pywal and integrations
  pywal.theme = "gruvbox";
  pywal.background = assets.wallpaper-astronaut-gruvbox;

  # Set cursor theme
  wayland.windowManager.sway.config ={
    seat."*" = {
      xcursor_theme = "Capitaine\\ Cursors\\ (Gruvbox)\\ -\\ White";
    };
  };

  # Theme command line tools
  programs.bat.config.theme = "gruvbox-dark";
  programs.broot.settings.imports = [ "skins/dark-gruvbox.hjson" ];

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "gruvbox-dark";
  programs.i3status-rust.bars.bottom.theme = "gruvbox-dark";

  # Set gtk look and feel
  gtk = {

    theme = {
      name = "Gruvbox-Dark";
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
