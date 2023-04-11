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

  # Enable desktop portal for screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
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
