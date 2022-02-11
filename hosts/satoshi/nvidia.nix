{ config, pkgs, lib, hardware, ... }:

let
  nvidia-x11 = config.boot.kernelPackages.nvidia_x11;
in {
  # Remove license warning
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
  ];

  # Specialization that boots with proprietary driver
  specialisation.nvidia.configuration = {
    # Enable prime offloading
    imports = [ hardware.common-gpu-nvidia ];

    # Provide nvidia kernel module
    boot.extraModulePackages = [ nvidia-x11 ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    hardware.nvidia = {
      package = nvidia-x11;

      # Set hardware identifier
      prime = {
        #TODO set offload?

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # 
      modesetting.enable = true;

      # Improve prime battery life
      powerManagement.enable = true;
    };

    # Add OpenGL VDPAU support
    hardware.opengl = {
      extraPackages = with pkgs; [ nvidia-x11.out libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs; [ nvidia-x11.lib32 libvdpau-va-gl vaapiVdpau ];
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
      WLR_NO_HARDWARE_CURSORS = "1"; 
    };
  };
}
