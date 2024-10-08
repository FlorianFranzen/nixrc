{ config, pkgs, lib, profiles, ... }:

let
  # Shorthand for current kernel package set
  kernelPkgs = config.boot.kernelPackages;

  # Select latest release for hardware support and bug fixes
  nvidiaPackage = kernelPkgs.nvidiaPackages.beta;

  # Specialization that boots with nvidia driver
  mkConfig = enableOpen: {
    # Enable prime offloading (incl. nvidia-offload wrapper)
    imports = [ profiles.hardware.common-gpu-nvidia ];

    # Enable bbswitch module
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernelPkgs.bbswitch ];

    # Enable resizable BAR support and fix bbswitch power management
    boot.kernelParams = [ "NVreg_EnableResizableBar=1" "pcie_port_pm=off" ];

    # FIXME hardware.nvidia should not require this to be set
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Add full opengl support
    hardware.graphics = {
      extraPackages = with pkgs; [
        (if enableOpen then nvidiaPackage.open else nvidiaPackage.out)
        libvdpau-va-gl
        vaapiVdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        (if enableOpen then nvidiaPackage.open else nvidiaPackage.lib32)
        libvdpau-va-gl
        vaapiVdpau
      ];
    };

    # Enable various hardware integrations
    hardware.nvidia = {
      # Allow control of version via input args
      open = enableOpen;

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
    };

    # Provide command line utils
    environment.systemPackages = [
      sway-nvidia-session
      pkgs.vulkan-tools
      pkgs.glmark2
    ];

    home-manager.users.florian.wayland.windowManager.sway.package = lib.mkForce pkgs.sway-nvidia;

    services.displayManager.sessionPackages = [ sway-nvidia-session ];
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
    nvidia.configuration = mkConfig true;
    nvidia-closed.configuration = mkConfig false;
  };
}
