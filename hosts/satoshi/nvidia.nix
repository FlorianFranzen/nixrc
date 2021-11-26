{ config, pkgs, lib, hardware, ... }:

let
  nvidia-x11 = config.boot.kernelPackages.nvidia_x11;
in {
  # Remove license warning 
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
  ];

  environment.systemPackages = with pkgs; [ wineWowPackages.staging winetricks ];

  # Specialization that boots with proprietary driver
  specialisation.nvidia.configuration = {
    # Enable prime offloading
    imports = [ hardware.common-gpu-nvidia ];

    # Provide nvidia kernel module
    boot.extraModulePackages = [ nvidia-x11 ];

    # Reenable gpu
    hardware.nvidiaOptimus.disable = false;

    hardware.nvidia = {
      # Set hardware identifier
      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Improve prime battery life
      powerManagement.enable = true;
    };

    # Add OpenGL VDPAU support 
    hardware.opengl = {
      extraPackages = with pkgs; [ nvidia-x11.out libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs; [ nvidia-x11.lib32 libvdpau-va-gl vaapiVdpau ];
    };

    # Provide command line utils
    environment.systemPackages = [ nvidia-x11 ];
  };
}
