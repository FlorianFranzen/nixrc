{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    { command = "${pkgs.workstyle}/bin/workstyle"; always = true; }
  ];

  home.file.".config/workstyle/config.toml".text = ''
    "picture-in-picture" = ""
    "private browsing" = ""
    "github" = ""
    "firefox" = ""
    "chromium" = ""
    "thunderbird" = "󰇮"
    "file manager" = ""
    "libreoffice calc" = ""
    "libreoffice writer" = ""
    "libreoffice" = ""
    "inkscape" = ""
    "gnu image manipulation program" = ""
    "emacs" = ""
    "gthumb" = ""
    "element" = ""
    "slack" = "󰒱"
    "calculator" = ""
    "steam" = ""
    "skype" = ""

    [other]
    "fallback_icon" = ""
  '';
}
