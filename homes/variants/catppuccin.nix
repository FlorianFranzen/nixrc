{ pkgs, lib, ... }:

{
  # Enable custom configuration module
  catppuccin = {
    autoEnable = true;
    enable = true;
    accent = "green";
    flavor = "mocha";

    firefox.force = true;
  };

  # Install additional theming
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "green" ];
    })
  ];

  # Disable pywal
  pywal.enable = lib.mkForce false;

  # Custominze sway further
  wayland.windowManager.sway.config = {
    # Set desktop background
    output."*".background = "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha.passthru.gnomeFilePath} fill";
    
    # Set cursor theme
    seat."*" = {
      xcursor_theme = "Catppuccin\\ Latte\\ Light";
    };
  };

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "ctp-mocha";
  programs.i3status-rust.bars.bottom.theme = "ctp-mocha";

  # KDE plasma theming
  programs.plasma.workspace = {
    colorScheme = "CatppuccinMochaPeach";
    cursor = {
      size = 36;
      theme = "Catppuccin Latte Light";
    };
    iconTheme = "Papirus-Dark";
    theme = "CatppuccinMocha-Modern";
    wallpaper = pkgs.nixos-artwork.wallpapers.catppuccin-mocha.passthru.kdeFilePath;

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
      name = "catppuccin-mocha-green-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Catppuccin Latte Light";
      package = pkgs.catppuccin-cursors.latteLight;
    };
  };

  # Support Qt theming
  qt.style.name = "kvantum";
}
