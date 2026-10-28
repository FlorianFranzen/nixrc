# Default config for all hosts
{ config, lib, pkgs, ... }:

{
  # hostId, hostPlatform, key-only sshd and sudo via pam_rssh come from ftl
  # (the access module and the host metadata)

  # Only allow nix managed keys (local or remote)
  services.openssh.authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];

  # Admins copy closures to the hosts (until they push through sudo)
  fleet.nix.trustWheel = true;
 
  # Make every terminal's terminfo available, e.g. for foot over ssh
  environment.enableAllTerminfo = lib.mkDefault true;

  # Add cacert to global trust store
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];

  # Enable time synchronization
  services.timesyncd.enable = lib.mkDefault true;

  # Keep default system state version in sync
  system.stateVersion = lib.mkDefault "26.11";

  # Set default your time zone.
  time.timeZone = lib.mkDefault "Europe/Zurich";

  # Workstations keep the passwords set on them; sshd stays key-only
  fleet.access.localPasswords = true;

  # Disable theming by default
  catppuccin.enable = lib.mkDefault false;
  catppuccin.autoEnable = lib.mkDefault false;
}	

