# Default config for all hosts
{ config, lib, ... }:

{
  # Automatically generate default host id if zfs is enabled
  networking.hostId = lib.mkIf config.boot.zfs.enabled (lib.mkOverride 999 (
    lib.substring 0 8 (builtins.hashString "md5" config.networking.hostName)
  ));

  # Enable SSH login via key by default
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PasswordAuthentication = lib.mkDefault false;

  # Only allow nix managed keys (local or remote)
  services.openssh.authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];

  # Allow key-based auth (local and via ssh)
  security.pam.sshAgentAuth = {
    enable = lib.mkDefault true;
  };

  # Enable time synchronization
  services.timesyncd.enable = lib.mkDefault true;

  # Set default your time zone.
  time.timeZone = lib.mkDefault "Europe/Zurich";

  # Allow locally managed user by default
  users.mutableUsers = lib.mkDefault true;
}	
