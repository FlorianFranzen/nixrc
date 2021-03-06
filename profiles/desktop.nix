# Base config to run a desktop environment

{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;

    # Add upstream patch to enable experimental mode
    package = pkgs.bluez.overrideAttrs (old: {
      patches = [
        ./bluez_experimental.patch
      ];

      configureFlags = old.configureFlags ++ [ "--enable-experimental" ];
    });

    # Enable battery reporting
    settings.General.Experimental = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    shared_mime_info
    libappindicator
    libnotify
    xdg_utils

    playerctl

    pywal
    glib
    numix-cursor-theme
    numix-solarized-gtk-theme
    numix-icon-theme-square
    lxappearance

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
    chromium

    nextcloud-client
  ];

  # Enable backlight control
  programs.light.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable  = true;
  #services.printing.drivers = [ pkgs.gutenprint ];

  # Enable AVAHI
  #services.avahi.enable = true;

  # Enable dconf
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Enable gvfs
  services.gvfs.enable = true;
  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gnome3.gvfs}/lib/gio/modules" ];

  location = {
    latitude = 47.1;
    longitude = 8.5;
  };

  users.extraUsers.florian = {
    extraGroups = [ "audio" "video" ];
  };
}
