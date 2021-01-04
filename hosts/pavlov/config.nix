{ config, pkgs, lib, ... }:

let
  nixrc = {
    profiles = [ "minimal" ];
    services = [ "hydra" ];
  };

  attrsToImports = input:
    lib.lists.flatten
      (lib.attrsets.mapAttrsToList
        (dir: map (f: ./../.. + "/${dir}/${f}.nix")) 
      input);
in
{

  imports = attrsToImports nixrc;
   
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Enable Wake on LAN
  services.wakeonlan.interfaces = [
    { interface = "enp3s0"; method = "magicpacket"; }
  ];

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

  system.stateVersion = "20.09";
}
