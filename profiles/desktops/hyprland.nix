{ pkgs, ... }:

{
  # Include base desktop profile
  imports = [ ./base.nix ];

  # Install some base necessities
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qtstyleplugins
    qt6gtk2
    vulkan-validation-layers
    wl-clipboard
  ];

  hardware.opengl.enable = true;

  fonts.enableDefaultPackages = true;

  programs.dconf.enable = true;

  security.polkit.enable = true;

  # Add hyprland to login screen selection
  services.displayManager.sessionPackages = [ pkgs.hyprland ];

  # Allow swaylock to check passwords
  security.pam.services.swaylock = {};
}
