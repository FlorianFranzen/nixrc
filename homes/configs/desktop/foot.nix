{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings.main.dpi-aware = "no";
  };

  home.packages = [ pkgs.libsixel ];

  # Enable notification
  services.lorri.enableNotifications = true;
}
