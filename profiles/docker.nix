{ config, pkgs, ... }:

{  
  # Enable docker 
  virtualisation.docker.enable = true;

  users.extraUsers.florian = {
    extraGroups = [ "docker" ]; 
  };
}
