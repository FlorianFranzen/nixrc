{ config, pkgs, username, ... }:

{
  # Enable docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Otherwise waits for network-online
    storageDriver = "btrfs";
  };

  # Useful packages
  environment.systemPackages = [ pkgs.docker-compose ];

  # Give certain users direct access
  users.extraUsers.${username} = {
    extraGroups = [ "docker" ];
  };
}
