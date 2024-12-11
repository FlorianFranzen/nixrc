{ pkgs, ... }:

let
  # Fonts to use across configs
  monoFont = "JetBrains Mono";
  iconFont = "JetBrainsMono Nerd Font";

  # Default font size
  size = 12;

  # Helper functions
  toFloat = n: n + 0.0;
in {
  # Manage fonts in usersapce
  fonts.fontconfig.enable = true;

  # Install default font 
  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-emoji
  ];

  # Configure font in various apps
  wayland.windowManager.sway.config.fonts = {
    names = [ monoFont iconFont ];
    style = "Regular";
    size = toFloat size;
  };

  programs.alacritty.settings.font = {
    normal.family = iconFont;
    inherit size;
  };

  programs.foot.settings.main.font = "${iconFont}:size=${toString size}";

  programs.plasma.fonts.fixedWidth = {
    family = monoFont;
    pointSize = size;
  };

  services.mako.font = "${iconFont} ${toString size}";
}
