{ config, pkgs, username, ... }:

{
  # Enable wireshark and ui
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  users.extraUsers.${username}.extraGroups = [ "wireshark" ];
}
