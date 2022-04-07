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

  # Enable ozone wayland backend
  nixpkgs.overlays = [
    (self: super: {
      element-desktop = super.element-desktop-wayland;
      chromium = super.chromium-wayland;
      signal-desktop = super.signal-desktop-wayland;
    })
  ];

  # Enable desktop portal
  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];

  # Install sway
  programs.sway = {
    enable = true;

    # Leave all other additional tools to user
    extraPackages = [];

    # Enable gtk for proper app support
    wrapperFeatures.gtk = true;
  };

  # Enable xwayland support
  programs.xwayland.enable = true;

  # Give main user access
  users.extraUsers.florian = {
    extraGroups = [ "sway" ];
  };

  # Trigger graphical user session on sway start
  systemd.user.targets.sway-session = {
    description = "sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target"  ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  environment.etc."sway/config.d/10-systemd".text = ''
    exec "systemctl --user import-environment; systemctl --user start sway-session.target"
  '';
}
