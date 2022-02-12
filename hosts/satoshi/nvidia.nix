{ config, pkgs, lib, hardware, ... }:

let
  nvidia-x11 = config.boot.kernelPackages.nvidia_x11;
in {
  # Remove license warning
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
  ];

  # FIXME Specialization should be able to set kernel params
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # FIXME Specialization should stay activate on switch
  hardware.opengl = {
    extraPackages = with pkgs; [ nvidia-x11.out libvdpau-va-gl vaapiVdpau ];
    extraPackages32 = with pkgs; [ nvidia-x11.lib32 libvdpau-va-gl vaapiVdpau ];
  };

  # Specialization that boots with proprietary driver
  specialisation.nvidia.configuration = {
    # Enable prime offloading
    imports = [ hardware.common-gpu-nvidia ];

    # Provide nvidia kernel module
    boot.extraModulePackages = [ nvidia-x11 ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Enable various hardware integrations
    hardware.nvidia = {
      package = nvidia-x11;

      # Enable prime offloading
      prime = {
        offload.enable = true;
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Needed for wayland support
      modesetting.enable = true;

      # Improve prime battery life
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };

    # Provide command line utils
    environment.systemPackages = [ 
      nvidia-x11 
      pkgs.vulkan-tools
      pkgs.glmark2
    ];

    # Use nvidia on wayland
    environment.variables = {
      # TODO Investigate these
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      WLR_DRM_NO_ATOMIC = "1";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_DRM_DEVICES = "/dev/dri/card1";  
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
