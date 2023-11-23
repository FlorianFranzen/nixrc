{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    cura
    prusa-slicer
    super-slicer
  ];

  users.extraUsers.${username}.extraGroups = [ "dialout" ];
}

