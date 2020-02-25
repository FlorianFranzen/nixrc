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
      # Set default keyboard layout
      export XKB_DEFAULT_LAYOUT=us
      export XKB_DEFAULT_OPTIONS=compose:ralt

      # Enable libappindicator support
      export XDG_CURRENT_DESKTOP=Unity   

      # Enable wayland backend   
      export XDG_SESSION_TYPE=wayland

      # Use GTK3 wayland backend
      export GDK_BACKEND=wayland
      export CLUTTER_BACKEND=wayland

      # Use SDL wayland backend
      export SDL_VIDEODRIVER=wayland

      # Use Qt wayland backend
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

      # Fix Java AWT applications
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Use GTK theme and integration
      export DESKTOP_SESSION=gnome
      export QT_QPA_PLATFORMTHEME=gtk2

      # Fix gsettings
      XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    ''; 
    extraPackages = with pkgs; [ 
      swaylock
      swayidle
      xwayland
      i3status-rust
      termite
      mako
      #waybar # Not in unstable yet...
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
}
