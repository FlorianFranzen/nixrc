{ config, pkgs, username, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Some general packages to improve wayland
  environment.systemPackages = with pkgs; [
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
}
