{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    { command = "${pkgs.workstyle}/bin/workstyle"; }
  ];

  home.file.".config/workstyle/config.toml".text = ''
    "picture-in-picture" = ""
    "private browsing" = ""
    "firefox" = ""
    "chromium" = ""
    "file manager" = ""
    "libreoffice calc" = ""
    "libreoffice writer" = ""
    "libreoffice" = ""
    "inkscape" = ""
    "gnu image manipulation program" = ""
    "emacs" = ""
    "gthumb" = ""
    "menu" = ""
    "element" = ""
    "calculator" = ""
    "steam" = ""
    "skype" = ""

    [other]
    "fallback_icon" = ""
  '';
}
