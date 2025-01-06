# Base config to run a desktop environment
{ pkgs, username, ... }:

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

    # Allow the sharing of gamepads
    input.General.ClassicBondedOnly = false;
  };

  # Link desktop portal configs
  environment.pathsToLink = [ "/share/xdg-desktop-portal" ];

  # Add bluetooth command line tooling
  environment.systemPackages = [ pkgs.bluez-tools ];

  # Enable dbus disk and power integration
  services.udisks2.enable = true;
  services.upower.enable = true;

  # Fix DNS resolution in browsers
  networking.resolvconf.dnsExtensionMechanism = false;

  # Give default user additional access to devices
  users.extraUsers.${username}.extraGroups = [ "audio" "cdrom" "video" ];
}
