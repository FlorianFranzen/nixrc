{ pkgs, ... }:

let
  # Fonts to use across configs
  generalFont = "Inter";
  monoFont = "JetBrains Mono";
  iconFont = "JetBrainsMono Nerd Font";

  # Default font size
  size = 12;

  # Helper functions
  toFloat = n: n + 0.0;
in
{
  # Manage fonts in usersapce
  fonts.fontconfig.enable = true;

  # Install default font
  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    inter
    inter-nerdfont
    input-fonts
    input-nerdfont
  ];

  # Configure font in various apps
  wayland.windowManager.sway.config.fonts = {
    names = [
      monoFont
      iconFont
    ];
    style = "Regular";
    size = toFloat size;
  };

  programs.alacritty.settings.font = {
    normal.family = iconFont;
    inherit size;
  };

  programs.foot.settings.main.font = "${iconFont}:size=${toString size}";

  programs.plasma.fonts = {
    fixedWidth = {
      family = monoFont;
      pointSize = size;
    };
    general = {
      family = generalFont;
      pointSize = size;
      styleHint = "serif";
    };
    menu = {
      family = generalFont;
      pointSize = size - 1;
    };
    small = {
      family = generalFont;
      pointSize = size - 2;
    };
    toolbar = {
      family = generalFont;
      pointSize = size - 1;
    };
    windowTitle = {
      family = generalFont;
      pointSize = size;
      weight = "bold";
    };
  };

  services.mako.settings.font = "${iconFont} ${toString size}";
}
