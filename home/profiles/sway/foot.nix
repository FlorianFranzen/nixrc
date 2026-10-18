{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    server.enable = true;

    settings = {
      main.dpi-aware = "no";
      scrollback.lines = 10000;
    };
  };

  # Support sixel graphics
  home.packages = [ pkgs.libsixel ];
}
