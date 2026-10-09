{ pkgs, ... }:

{
  # Some general tooling for wayland
  home.packages = with pkgs; [
    playerctl
    wl-clipboard
    xdg-utils
    shared-mime-info
  ]; 
}
