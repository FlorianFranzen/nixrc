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

  services.udisks2.enable = true;
  services.upower.enable = true;

  # Install sway
  programs.sway-beta = {
    enable = true;
    extraSessionCommands = ''
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
    ''; 
    extraPackages = with pkgs; [ 
      swaylock
      swayidle
      xwayland
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

  systemd.user.targets.sway-session = {
    bindsTo = [ "graphical-session.target"  ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };
}
