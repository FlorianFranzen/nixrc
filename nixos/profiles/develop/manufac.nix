{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    cura-appimage
    prusa-slicer
    super-slicer
  ];

  users.extraUsers.${username}.extraGroups = [ "dialout" ];
}

