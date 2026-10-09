{ config, pkgs, username, ... }:

{
  # Enable sniffnet
  programs.sniffnet.enable = true;

  # Enable wireshark and ui
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.extraUsers.${username}.extraGroups = [ "wireshark" ];
}
