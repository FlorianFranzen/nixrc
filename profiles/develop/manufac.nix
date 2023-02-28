{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    cura
    prusa-slicer
    super-slicer
  ];

  users.extraUsers.florian.extraGroups = [ "dialout" ];
}

