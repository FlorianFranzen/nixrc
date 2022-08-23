{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    { command = "${pkgs.workstyle}/bin/workstyle"; }
  ];

  home.file.".config/workstyle/config.toml".text = ''
    "alacritty" = ""
    "foot" = ""
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
    "transmission" = ""
    "videostream" = ""
    "mpv" = ""
    "music" = ""
    "steam" = ""
    "skype" = ""
    "disk usage" = ""
    "documents" = ""
    ".pdf" = ""

    [other]
    "fallback_icon" = ""
  '';
}
