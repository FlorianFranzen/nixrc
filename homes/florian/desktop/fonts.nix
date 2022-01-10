{ pkgs, ... }:

let
  # One font to rule them all
  name = "JetBrainsMono";
  size = 12;

  # Helper functions
  toFloat = n: n + 0.0;
in {
  # TODO: Use user installed font
  #fonts.fontconfig.enable = true;
  #home.packages = with pkgs; [
  #  jetbrains-mono
  #  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  #];

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
