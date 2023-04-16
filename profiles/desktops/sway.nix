{ config, pkgs, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Some general packages to improve wayland
  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    libsForQt5.qtstyleplugins
    wl-clipboard
  ];

  # Add sway to supported sessions
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];

  # Enable desktop portal for screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable xwayland support
  programs.xwayland.enable = true;

  # Give main user access
  users.extraUsers.florian = {
    extraGroups = [ "sway" ];
  };

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};
}
