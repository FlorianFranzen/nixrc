{ pkgs, username, ... }:

{
  programs.adb.enable = true;

  users.extraUsers.${username}.extraGroups = [ "adbusers" ];
}
