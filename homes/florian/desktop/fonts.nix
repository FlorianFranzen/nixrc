{ pkgs, ... }:

let
  # One font to rule them all
  name = "JetBrainsMono";
  size = 12;

  # Helper functions
  toFloat = n: n + 0.0;
in {
  # Manage fonts in usersapce
  fonts.fontconfig.enable = true;

  # Install default font 
  home.packages = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Configure font
  wayland.windowManager.sway.config.fonts = {
    names = [ name "${name} Nerd Font" ];
    style = "Regular";
    size = toFloat size;
  };

  programs.alacritty.settings.font = {
    normal.family = name;
    inherit size;
  };

  programs.foot.settings.main.font = "${name}:size=${toString size}";

  programs.mako.font = "${name} ${toString size}";
}
