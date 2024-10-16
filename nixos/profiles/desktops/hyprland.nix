{ pkgs, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Install some base necessities
  hardware.graphics.enable = true;

  fonts.enableDefaultPackages = true;

  programs.dconf.enable = true;

  security.polkit.enable = true;

  # Add hyprland to login screen selection
  services.displayManager.sessionPackages = [ pkgs.hyprland ];

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};
}
