{ pkgs, ... }:

{
  programs.adb.enable = true;

  users.extraUsers.florian.extraGroups = [ "adbusers" ];
}
