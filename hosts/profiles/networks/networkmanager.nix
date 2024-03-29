{ config, pkgs, username, ... }:

{
  # Use network manager
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";

    ethernet.macAddress = "random";

    wifi = {
      macAddress = "random";
    };
  };

  environment.systemPackages = [ pkgs.networkmanagerapplet ];

  # Enable network manager tray
  programs.nm-applet.enable = true;

  # List of users able to control network manager
  users.extraUsers.${username}.extraGroups = [ "networkmanager" ];
}
