{ config, pkgs, lib, profiles, homes, ... }:

{
  imports = (with profiles.services; [ hydra jellyfin ])
         ++ (with profiles.develop; [ minimal cross linux ])
         ++ (with profiles.desktops; [ lightdm hyprland ])
         ++ (with profiles.hardware; [ 
           common-cpu-intel common-gpu-intel 
           common-gpu-nvidia-disable
           common-pc-ssd
           pipewire
         ]);

  # Install full desktop environment
  home-manager.users.florian = homes.desktop-solarized;

  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

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

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "22.11";
}
