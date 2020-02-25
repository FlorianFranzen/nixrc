# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
 
 boot = {
    # Hybrid 32bit UEFI but 64bit Atom CPU	  
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      forcei686 = true;
    };

    # Full hardware support requires recent kernel (5.4)
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Fix for freezing (TODO might be fixed in recent kernel or require patch)
    kernelParams = [
      "intel_idle.max_cstate=1" 
    ];

    # Add necessary modules for internal keyboard support during early boot
    initrd.availableKernelModules = [ "i2c_designware_platform" "i2c_hid" "hid_asus" ];
  
    # Fix for quirky sdio sound card
    extraModprobeConfig = ''
      options snd_soc_rt5645 quirk=0x31
    '';
  };

  # Compile kernel with opregion support
  nixpkgs.config.packageOverrides = before: {
    linux_latest = before.linux_latest.override {
	extraConfig = ''
	  I2C y
	  ACPI_I2C_OPREGION y
	'';
    };
  };

  networking.hostName = "hull"; 
}

