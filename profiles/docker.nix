{ config, pkgs, ... }:

{  
  # Enable docker 
  virtualisation.docker.enable = true;

  # Useful packages 
  environment.systemPackages = [ pkgs.docker-compose ];

  # Give certain users direct access
  users.extraUsers.florian = {
    extraGroups = [ "docker" ]; 
  };
}
