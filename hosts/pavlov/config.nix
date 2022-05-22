{ config, pkgs, lib, services, ... }:

{
  imports = with services; [ hydra jellyfin ];

  # Do not use home-manager on this host
  home-manager.users.florian = {};

  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Enable cross compiling of aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Enable Wake on LAN
  networking.interfaces.enp3s0.wakeOnLan.enable = true;

  # Suspend on power button press
  services.logind.extraConfig = "HandlePowerKey=suspend";

  # Backup samba share
#  services.samba = {
#    enable = true;
#    extraConfig = ''
#      guest account = nobody
#      map to guest = bad user
#    '';
#    shares = {
#      wanderer = {
#	browsable = true;
#	writable = true;
#	public = true;
#        path = "/data/wanderer";
#      };
#      addy = {
#        browseable = true;
#	writable = true;
#        public = true;
#	path = "/data/addy";
#      };
#    };
#  };

  system.stateVersion = "21.11";
}
