{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.

  networking.hostName = "bbo3038";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enableCryptodisk = true;
    };
    
    initrd.kernelModules = [ "i915" ];

    # Check nix-hardware for why
    #kernelModules = [ "acpi_call" ]; 
    #extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport32Bit = true;
 
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
#      linuxPackages.nvidia_x11.out
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [ 
        vaapiIntel 
        libvdpau-va-gl 
        vaapiVdpau 
#       linuxPackages.nvidia_x11.out 
      ];
    };

#    bumblebee = {
#      enable = true;
#      driver = "nouveau";
#    };
   
    nvidiaOptimus.disable = true; 
    
    trackpoint.enable = true;
  };

}
