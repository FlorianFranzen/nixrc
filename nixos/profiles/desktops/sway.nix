{ config, pkgs, username, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Enable dconf and gcr
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf pkgs.gcr ];
  
  # Enable fs integration
  services.gvfs.enable = true;

  # Enable dbus disk and power integration
  services.udisks2.enable = true;
  services.upower.enable = true;

  # Some general packages to improve wayland
  environment.systemPackages = with pkgs; [
    swaybg
    qt5.qtwayland
    qt6.qtwayland
    vulkan-validation-layers
  ];

  # Add sway to supported sessions
  services.displayManager.sessionPackages = [ pkgs.sway ];

  # Enable xwayland support
  programs.xwayland.enable = true;

  # Give main user access to sway
  users.extraUsers.${username}.extraGroups = [ "sway" ];

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};

  # Run stand-alone GTK polkit agent
  security.soteria.enable = true;
}
