# Base config to run a desktop environment

{ config, pkgs, ... }:

{
  # Enable ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;

    # Use bluez with experimental features
    package = pkgs.bluez5-experimental;

    # Enable experimental battery reporting
    settings.General.Experimental = true;
  };

  # Disable hsphfpd demo client
  systemd.user.services.telephony_client.enable = false;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    shared-mime-info
    libappindicator
    libnotify
    xdg-utils

    playerctl

    pywal
    glib
    numix-cursor-theme
    numix-solarized-gtk-theme
    numix-icon-theme-square
    lxappearance

    gnome.eog
    gnome.ghex
    gnome.file-roller
    gnome.nautilus
    gnome.sushi

    xfce.xfconf
    xfce.mousepad
    (xfce.thunar.override { thunarPlugins = [
      xfce.thunar-volman
      xfce.thunar-archive-plugin
    ];})
    xfce.ristretto
    xfce.tumbler
    xfce.orage

    lxqt.lxqt-policykit
    lxqt.qps

    firefox
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

  # Default location: Zürich
  location = {
    latitude = 47.1;
    longitude = 8.5;
  };

  # Fix DNS resolution in browsers
  networking.resolvconf.dnsExtensionMechanism = false;

  users.extraUsers.florian = {
    extraGroups = [ "audio" "video" ];
  };
}
