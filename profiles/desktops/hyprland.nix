{ pkgs, ... }:

{
  hardware.opengl.enable = true;

  fonts.enableDefaultFonts = true;

  programs.dconf.enable = true;

  security.polkit.enable = true;

  services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
