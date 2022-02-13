{ config, pkgs, lib, hardware, ... }:

let
  nvidia-x11 = config.boot.kernelPackages.nvidia_x11;
in {
  # Remove license warning
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-persistenced" "nvidia-settings"
  ];

  # FIXME Specialization should stay activate on switch
  hardware.opengl = {
    extraPackages = with pkgs; [ nvidia-x11.out libvdpau-va-gl vaapiVdpau ];
    extraPackages32 = with pkgs; [ nvidia-x11.lib32 libvdpau-va-gl vaapiVdpau ];
  };

  # Specialization that boots with proprietary driver
  specialisation.nvidia.configuration = {
    # Enable prime offloading (incl. nvidia-offload wrapper)
    imports = [ hardware.common-gpu-nvidia ];

    # FIXME hardware.nvidia should not require this to be set
    services.xserver.videoDrivers = [ "nvidia" ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    # Enable various hardware integrations
    hardware.nvidia = {
      package = nvidia-x11;

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
    };

    # Provide command line utils
    environment.systemPackages = [ 
      nvidia-x11 
      pkgs.vulkan-tools
      pkgs.glmark2
    ];

    # Use nvidia on wayland
    environment.variables = {
      # Use internal card by default, with prime offloading
      WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";  
      # Use nvidia gbm backend
      GBM_BACKEND = "nvidia-drm";
    };
  };
}
