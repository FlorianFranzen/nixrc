{ pkgs, ... }:

{
  # Collection of random software waiting for proper integration
  home.packages = with pkgs; [
    (xfce.thunar.override { thunarPlugins = [
      xfce.thunar-volman
      xfce.thunar-archive-plugin
    ];})
    xfce.ristretto
    xfce.tumbler
    #xfce.orage

    ghex
    file-roller

    #lxqt.lxqt-policykit
    #lxqt.qps

    librewolf
    ungoogled-chromium

    nextcloud-client
  ];
}
