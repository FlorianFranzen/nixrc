{ config, pkgs, ... }:

{
  # Enable docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Otherwise waits for network-online
  };

  # Useful packages
  environment.systemPackages = [ pkgs.docker-compose ];

  # Give certain users direct access
  users.extraUsers.florian = {
    extraGroups = [ "docker" ];
  };
}
