{ config, pkgs, ... }:

{
  # Enable wireshark and ui
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  users.extraUsers.florian.extraGroups = [ "wireshark" ];
}
