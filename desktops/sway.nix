{ config, pkgs, ... }:

{
  # Enable waybar sway support
  nixpkgs.config.packageOverrides = pkgs: {
    waybar = pkgs.waybar.override {
      pulseSupport = true;
      swaySupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    libsForQt5.qtstyleplugins
    wl-clipboard
    grim
    slurp
  ];

  services.udisks2.enable = true;
  services.upower.enable = true;

  # Install sway
  programs.sway = {
    enable = true;
    extraSessionCommands = let 
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      # Set default keyboard layout (still needed?)
      export XKB_DEFAULT_LAYOUT=eu
      export XKB_DEFAULT_OPTIONS=compose:ralt

      # Enable libappindicator support
      export XDG_CURRENT_DESKTOP=Unity

      # Enable wayland backends 
      export XDG_SESSION_TYPE=wayland

      # Use CLUTTER wayland backend
      export CLUTTER_BACKEND=wayland

      # Enable mozilla wayland backend
      export MOZ_ENABLE_WAYLAND=1

      # Enable LibreOffice gtk3 backend
      export SAL_USE_VCLPLUGIN=gtk3

      # Use SDL wayland backend
      export SDL_VIDEODRIVER=wayland

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

    extraPackages = with pkgs; [ 
      swaylock
      swayidle
      xwayland
      i3status-rust
      alacritty
      mako
      waybar
      rofi
    ];
  };
  
  programs.waybar.enable = true;


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

  # Start swayidle service
  systemd.user.services.swayidle = {
    description = "Idle manager for wayland";
    documentation = [ "man:swayidle(1)" ];
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = with pkgs; [ sway swayidle swaylock ];
    script = ''
      swayidle -w \
        timeout 600 'swaylock -f' \
        timeout 900 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"'  \
        before-sleep 'swaylock -f'
      '';
  };

  # Enable redshift
  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
  };

  # Start mako service
  systemd.user.services.mako = {
    description = "A lightweight Wayland notification daemon";
    documentation = [ "man:mako(1)" ];
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.mako}/bin/mako";
  };
}
