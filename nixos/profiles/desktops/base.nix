# Base config to run a desktop environment
{ lib, pkgs, username, ... }:

{
  # Enable ntfs support
  boot.supportedFilesystems = [ "exfat" "ntfs" ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;

    # Use bluez with experimental features
    package = pkgs.bluez5-experimental;

    settings.General = {
      # Enable experimental battery reporting
      Experimental = true;

      # Allow faster connection
      FastConnectable = true;
    };

    input.General = {
      # Allow the sharing of gamepads
      ClassicBondedOnly = false;

      # Force use of userspace hid
      UserspaceHID = true;
    };
  };

  # Link desktop portal configs and applications
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  # Add bluetooth command line tooling
  environment.systemPackages = [ pkgs.bluez-tools ];

  # Use more reliable dbus implementation by default
  services.dbus.implementation = lib.mkDefault "broker";

  # Give default user additional access to devices
  users.extraUsers.${username}.extraGroups = [ "audio" "cdrom" "video" ];
}
