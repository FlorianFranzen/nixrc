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
  ];

  # Install sway
  programs.sway-beta = {
    enable = true;
    extraSessionCommands = ''
      XDG_SESSION_TYPE=wayland

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
    ''; 
    extraPackages = with pkgs; [ 
      swaylock
      swayidle
      xwayland
      kitty
      mako
      #waybar # Not in unstable yet...
      rofi
    ];
  };

  # Give main user access
  users.extraUsers.florian = {
    extraGroups = [ "sway" ];
  };

  systemd.user.targets.sway-session = {
    bindsTo = [ "graphical-session.target"  ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };
}
