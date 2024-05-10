{ pkgs, ... }:

{
  # Collection of random software waiting for proper integration
  home.packages = with pkgs; [
    #gnome.eog
    gnome.ghex
    gnome.file-roller
    #gnome.nautilus
    #gnome.sushi

    #xfce.xfconf
    #xfce.mousepad
    (xfce.thunar.override { thunarPlugins = [
      xfce.thunar-volman
      xfce.thunar-archive-plugin
    ];})
    xfce.ristretto
    xfce.tumbler
    #xfce.orage

    #lxqt.lxqt-policykit
    #lxqt.qps

    librewolf
    ungoogled-chromium

    nextcloud-client
  ];
}
