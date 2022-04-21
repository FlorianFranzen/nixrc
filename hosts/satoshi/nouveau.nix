{ config, pkgs, lib, hardware, ... }:

let
  mkDesktopFile = name: exec: ''
    [Desktop Entry]
    Name=${name}
    Exec=${exec}
    Type=Application
  '';

  mkWaylandSession = name: exec: command:
    pkgs.runCommand name {
      inherit command;
      desktop = mkDesktopFile name exec;
      passAsFile = [ "command" "desktop" ];

      passthru = {
        providedSessions = [ exec ];
      };

      preferLocalBuild = true;
      allowSubstitutes = false;
    } ''
      mkdir -p $out/{bin,share/wayland-sessions}

      session=$out/bin/${exec}
      echo "#!${pkgs.runtimeShell}" > $session
      cat $commandPath >> $session
      chmod +x $session

      mv $desktopPath $out/share/wayland-sessions/${exec}.desktop
    '';

  # Provide nvidia based sway session at login
  nouveau-sway = mkWaylandSession "Sway (Nouveau)" "nouveau-sway" ''
      export WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
      export WLR_DRM_NO_MODIFIERS=1
      export WLR_NO_HARDWARE_CURSORS=1
      exec -a nouveau-sway sway $@
  '';
in {
  # Specialization that boots with proprietary driver
  specialisation.nouveau.configuration = {
    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Enable various hardware integrations
    hardware.bumblebee = {
      enable = false;
      driver = "nouveau";
      pmMethod = "auto";
      connectDisplay = true;
    };
    
    # Provide wrapped session command
    environment.systemPackages = [ nouveau-sway ];
    services.xserver.displayManager.sessionPackages = [ nouveau-sway ];
  };
}
