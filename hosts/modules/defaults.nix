# Default config for all hosts
{ config, lib, ... }:

let
  # Config option aliases
  hasZfs = config.boot.zfs.enabled;
  hasSshd = config.services.openssh.enable;
in {
  # Automatically generate default host id if zfs is enabled
  networking.hostId = lib.mkIf hasZfs (lib.mkOverride 999 (
    lib.substring 0 8 (builtins.hashString "md5" config.networking.hostName)
  ));

  # Enable SSH login via key by default
  services.openssh.enable = lib.mkDefault true;

  services.openssh.settings.PasswordAuthentication = lib.mkIf hasSshd false;
  security.pam.enableSSHAgentAuth = lib.mkIf hasSshd true;

  # Enable time synchronization
  services.timesyncd.enable = lib.mkDefault true;

  # Set default your time zone.
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Override digga default
  # TODO Add encrypted passwd hashes
  users.mutableUsers = true;
}	
