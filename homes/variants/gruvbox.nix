{ pkgs, assets, ...}:

{
  # Install additional theming
  home.packages = [ 
    pkgs.kde-gruvbox 
  ];

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

  # KDE plasma theming
  programs.plasma.workspace = {
    colorScheme = "Gruvbox";
    cursor = {
      size = 36;
      theme = "Capitaine Cursors (Gruvbox) - White";
    };
    iconTheme = "Gruvbox-Plus-Dark";
    theme = "breeze-dark"; 
    wallpaper = "${assets.wallpaper-astronaut-gruvbox}";
      
    # FIXME: Needs to be packaged and installed
    windowDecorations = {
      library = "org.kde.kwin.aurorae";
      theme = "__aurorae__svg__ActiveAccentFrame";
    };
  };
  programs.plasma.configFile.kdeglobals.KDE.widgetStyle = "Fusion";

  # Set gtk look and feel
  gtk = {
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    cursorTheme = {
      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;
    };
  };
}
