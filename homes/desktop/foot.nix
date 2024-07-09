{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main.dpi-aware = "no";
      scrollback.lines = 10000;
    };
  };

  home.packages = [ pkgs.libsixel ];
}
