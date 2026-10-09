{ config, pkgs, username, ... }:

{
  # Enable docker
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # Useful packages
  environment.systemPackages = [ pkgs.podman-compose ];

  # Give certain users direct access
  users.extraUsers.${username}.extraGroups = [ "podman" ];
}
