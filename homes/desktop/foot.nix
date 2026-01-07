{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main.dpi-aware = "no";
      scrollback.lines = 10000;
    };
  };

  # Provide alias for desktop integration
  programs.zsh.shellAliases.open = "xdg-open";

  # Support sixel graphics
  home.packages = [ pkgs.libsixel ];
}
