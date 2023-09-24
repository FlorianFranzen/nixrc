{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings.main.dpi-aware = "no";
  };

  home.packages = [ pkgs.libsixel ];
}
