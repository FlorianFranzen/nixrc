{ pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    { command = "${pkgs.sworkstyle}/bin/sworkstyle"; }
  ];

  home.file.".config/sworkstyle/config.toml".text = ''
    "fallback" = ""

    [matching]
    "foot" = ""
    "Picture-in-Picture" = ""
    "Private Browsing" = ""
    "File Manager" = ""
    "LibreOffice Calc" = ""
    "LibreOffice Writer" = ""
    "LibreOffice" = ""
    "Inkscape" = ""
    "GNU Image Manipulation Program" = ""
    "emacs" = ""
    "Element" = ""
    "mpv" = ""
    "steam" = ""
    ".pdf" = ""
  '';
}
