# Base config to run a desktop environment

{ config, pkgs, username, ... }:

{
  # Enable ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;

    # Use bluez with experimental features
    package = pkgs.bluez5-experimental;

    # Enable experimental battery reporting
    settings.General.Experimental = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    bluez-tools
    glib
    libappindicator
    libnotify
    playerctl
    shared-mime-info
    xdg-utils

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

  # Enable backlight control
  programs.light.enable = true;

  # Enable dconf and gcr
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf pkgs.gcr ];

  # Enable userspace mounting
  services.udisks2.enable = true;
  services.upower.enable = true;

  # Enable gvfs
  services.gvfs.enable = true;

  # Fix DNS resolution in browsers
  networking.resolvconf.dnsExtensionMechanism = false;

  users.extraUsers.${username} = {
    extraGroups = [ "audio" "video" ];
  };
}
