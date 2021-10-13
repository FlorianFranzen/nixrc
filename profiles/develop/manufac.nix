{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    cura
  ];

  users.extraUsers.florian = {
    extraGroups = [ "dialout" ];
  };
}

