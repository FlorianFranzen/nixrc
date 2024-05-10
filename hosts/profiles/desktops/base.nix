# Base config to run a desktop environment
{ pkgs, username, ... }:

{
  # Enable ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

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

  # Add bluetooth command line tooling
  environment.systemPackages = [ pkgs.bluez-tools ];

  # Enable dconf and gcr
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf pkgs.gcr ];

  # Enable dbus disk, fs and power integration
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;

  # Fix DNS resolution in browsers
  networking.resolvconf.dnsExtensionMechanism = false;

  # Give default user additional access to devices
  users.extraUsers.${username}.extraGroups = [ "audio" "video" ];
}
