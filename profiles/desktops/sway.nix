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
    extraOptions = [ "--my-next-gpu-wont-be-nvidia" ];
    extraSessionCommands = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      # Set default keyboard layout (still needed?)
      export XKB_DEFAULT_LAYOUT=eu
      export XKB_DEFAULT_OPTIONS=compose:ralt

      # Enable libappindicator support
      export XDG_CURRENT_DESKTOP=sway

      # Enable wayland backends
      export XDG_SESSION_TYPE=wayland

      # Use CLUTTER wayland backend
      export CLUTTER_BACKEND=wayland

      # Enable mozilla wayland backend
      export MOZ_ENABLE_WAYLAND=1

      # Enable smooth scrolling
      export MOZ_USE_XINPUT2=1

      # Enable mozilla dbus
      export MOZ_DBUS_REMOTE=1

      # Enable LibreOffice gtk3 backend
      export SAL_USE_VCLPLUGIN=gtk3

      # Configure Qt wayland backend
      export QT_WAYLAND_FORCE_DPI=physical
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      # Fix Java AWT applications
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Use GTK theme and integration
      export DESKTOP_SESSION=gnome
      export QT_QPA_PLATFORMTHEME=gtk2

      # Fix gsettings
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    '';

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
