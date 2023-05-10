{ config, pkgs, lib, hardware, ... }:

let
  # Select latest release for hardware support and bug fixes
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.latest;

  # Specialization that boots with nvidia driver
  mkConfig = hwOverride: {
    # Enable prime offloading (incl. nvidia-offload wrapper)
    imports = [ hardware.common-gpu-nvidia ];

    # Enable resizable BAR support
    boot.kernelParams = [ "NVreg_EnableResizableBar=1" ];

    # FIXME hardware.nvidia should not require this to be set
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Add full opengl support
    hardware.opengl = {
      extraPackages = with pkgs; [ nvidiaPackage.out nvidiaPackage.open libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs; [ nvidiaPackage.lib32 libvdpau-va-gl vaapiVdpau ];
    };

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

      # Use same package version to set up module
      package = nvidiaPackage; 

      # Improve prime battery life
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    } // hwOverride;

    # Provide command line utils
    environment.systemPackages = [
      sway-nvidia-session
      pkgs.vulkan-tools
      pkgs.glmark2
    ];

    home-manager.users.florian.wayland.windowManager.sway.package = lib.mkForce pkgs.sway-nvidia;

    services.xserver.displayManager.sessionPackages = [ sway-nvidia-session ];
  };

  # Provide nvidia based sway session at login
  sway-nvidia-session = pkgs.runCommand "sway-nvidia-session" {
    session = ''
      [Desktop Entry]
      Name=Sway (Nvidia)
      Exec=sway-nvidia
      Type=Application
    '';
    passAsFile = [ "session" ];

    passthru = {
      providedSessions = [ "sway-nvidia" ];
    };

    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    mkdir -p $out/{bin,share/wayland-sessions}

    ln -s ${pkgs.sway-nvidia}/bin/sway $out/bin/sway-nvidia
    mv $sessionPath $out/share/wayland-sessions/sway-nvidia.desktop
  '';
in {
  # Specialization that boots with proprietary and open nvidia driver
  specialisation = {
    nvidia.configuration = mkConfig {};
    nvopen.configuration = mkConfig { open = true; }; 
  };
}
