{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.android-tools ];
  users.extraUsers.${username}.extraGroups = [ "adbusers" ];
}
