{ config, pkgs, username, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Some general packages to improve wayland
  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qtstyleplugins
    qt6gtk2
    vulkan-validation-layers
    wl-clipboard
  ];

  environment.variables.QT_PLUGIN_PATH = [ "${pkgs.qt6gtk2}/lib/qt-6/plugins" ];

  # Add sway to supported sessions
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];

  # Enable desktop portal for screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ]; 
    };
  };

  # Enable xwayland support
  programs.xwayland.enable = true;

  # Give main user access to sway
  users.extraUsers.${username}.extraGroups = [ "sway" ];

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};
}
