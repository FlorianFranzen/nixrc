{ sway }:

sway.override {
  # Enable nvidia support
  extraOptions = [ "--unsupported-gpu" ];

  # Set some sane default environment variables
  extraSessionCommands = ''
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
    export QT_QPA_PLATFORM=wayland
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_WAYLAND_FORCE_DPI=physical
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    # Configure ozone backend for chromium apps
    export NIXOS_OZONE_WL=1

    # Configure SDL wayland backend
    export SDL_VIDEODRIVER=wayland

    # Fix Java AWT applications
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Use GTK theme and integration
    export DESKTOP_SESSION=gnome
    export QT_QPA_PLATFORMTHEME=gtk2

    # Use GTK portal if possible
    export GTK_USE_PORTAL=1
  '';

  withBaseWrapper = true;
  withGtkWrapper = true;
}