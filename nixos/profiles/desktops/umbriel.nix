{ pkgs, username, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Umbriel compositor: session, portal and user units; the noctalia shell
  # itself is configured in home-manager
  programs.umbriel.enable = true;

  # Enable dconf and gcr
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf pkgs.gcr_4 ];

  # Enable fs integration
  services.gvfs.enable = true;

  # Enable dbus disk and power integration
  services.udisks2.enable = true;
  services.upower.enable = true;

  # Some general packages to improve wayland
  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    vulkan-validation-layers
  ];

  # Noctalia registers its own polkit agent
  security.polkit.enable = true;

  # Give main user access to video devices
  users.extraUsers.${username}.extraGroups = [ "video" ];
}
