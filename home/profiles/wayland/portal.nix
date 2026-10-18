{ pkgs, ... }:

{
  xdg.portal = {
    # Install gtk portal, compositor specific backends are added per stack
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # Provide consistent experience with FHS
    xdgOpenUsePortal = true;
  };
}
