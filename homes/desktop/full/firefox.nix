{ pkgs, ... }:

{
  programs.firefox.profiles.default.extensions = with pkgs.firefox-addons; [ plasma-integration ];
}
