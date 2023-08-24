{ config, pkgs, ... }:

{
  # Enable docker
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # Useful packages
  environment.systemPackages = [ pkgs.docker-compose ];

  # Give certain users direct access
  users.extraUsers.florian = {
    extraGroups = [ "podman" ];
  };
}
