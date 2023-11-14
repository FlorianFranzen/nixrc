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
    "calibre" = ""
    "chromium" = ""
    "thunderbird" = "󰇮"
    "file manager" = ""
    "thunar" = ""
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
    "signal" = "󰭹"
    "steam" = ""
    "skype" = ""
    "zoom" = "󰵰"
    "zotero" = ""

    [other]
    "fallback_icon" = ""
  '';
}
