{ pkgs, ... }:

{
  # Use ozone wayland backedn
  environment.variables.NIXOS_OZONE_WL = 1;

  # Add additional image formats
  environment.systemPackages = [
    pkgs.kdePackages.kde-cli-tools
    pkgs.kdePackages.qtimageformats
  ];

  # Enable connect support
  programs.kdeconnect.enable = true;

  # Enable partition management
  programs.partition-manager.enable = true;

  # Enable lastest plasma release
  services.desktopManager.plasma6.enable = true;
}
