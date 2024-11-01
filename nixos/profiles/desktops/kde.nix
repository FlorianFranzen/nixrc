{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.kdePackages.qtimageformats
  ];

  programs.kdeconnect.enable = true;

  services.desktopManager.plasma6.enable = true;
}
