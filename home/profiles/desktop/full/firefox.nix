{ pkgs, ... }:

{
  programs.firefox.profiles.default.extensions.packages = with pkgs.firefox-addons; [ plasma-integration ];
}
