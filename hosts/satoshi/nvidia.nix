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

    # Set hardware identifier
    hardware.nvidia.prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Improve prime battery life
    hardware.nvidia.powerManagement.enable = true;

    # Provide command line utils
    environment.systemPackages = [ pkgs.linuxPackages.nvidia_x11 ];
  };
}
