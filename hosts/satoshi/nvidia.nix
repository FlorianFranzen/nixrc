{ config, pkgs, lib, hardware, ... }:

let
  # Specialization that boots with proprietary driver
  mkConfig = hwOverride: {
    # Enable prime offloading (incl. nvidia-offload wrapper)
    imports = [ hardware.common-gpu-nvidia ];

    # FIXME hardware.nvidia should not require this to be set
    services.xserver.videoDrivers = [ "nvidia" ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Enable various hardware integrations
    hardware.nvidia = {
      # Set hardware addresses
      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Needed for wayland support
      modesetting.enable = true;

      # Keep unused device in kernel
      nvidiaPersistenced = true;

      # Improve prime battery life
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    } // hwOverride;

    # Provide command line utils
    environment = {

      systemPackages = [ 
        nvidia-sway
        pkgs.vulkan-tools
        pkgs.glmark2
      ];

      # Use nvidia on wayland
      variables = {
        # Try nvidia gbm backend first
        GBM_BACKEND = "nvidia-drm";
      };
    };

    services.xserver.displayManager.sessionPackages = [ nvidia-sway ];
  };

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
  nvidia-sway = mkWaylandSession "Sway (Nvidia)" "nvidia-sway" ''
      export WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
      export WLR_NO_HARDWARE_CURSORS=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      exec -a nvidia-sway sway $@
  '';

  nvidia-x11 = config.boot.kernelPackages.nvidia_x11;
in {
  # FIXME Specialization should stay activate on switch
  hardware.opengl = {
    extraPackages = with pkgs; [ nvidia-x11.out nvidia-x11.open libvdpau-va-gl vaapiVdpau ];
    extraPackages32 = with pkgs; [ nvidia-x11.lib32 libvdpau-va-gl vaapiVdpau ];
  };

  # Specialization that boots with proprietary driver
  specialisation = {
    nvidia.configuration = mkConfig {};
    nvopen.configuration = mkConfig { open = true; }; 
  };
}
