{ pkgs, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  hardware.opengl.enable = true;

  fonts.enableDefaultPackages = true;

  programs.dconf.enable = true;

  security.polkit.enable = true;

  services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};
}
