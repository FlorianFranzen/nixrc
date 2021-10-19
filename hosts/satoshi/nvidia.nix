{ config, pkgs, lib, hardware, ... }:

{
  # Remove license warning 
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
  ];

  # Specialization that boots with proprietary driver
  specialisation.nvidia.configuration = {
    # Enable prime offloading
    imports = [ hardware.common-gpu-nvidia ];

    # Provide nvidia kernel module
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

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
      extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
    };

    # Provide command line utils
    environment.systemPackages = [ pkgs.linuxPackages.nvidia_x11 ];
  };
}
