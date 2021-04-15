{ config, pkgs, lib, ... }:

let
  nixrc = {
    profiles = [ "minimal" "media" "desktop" ];
    desktops = [ "sway" ];
    networks = [ "iwd" ];
    hardware = [ "yubikey" ];
  };

  attrsToImports = input:
    lib.lists.flatten
      (lib.attrsets.mapAttrsToList
        (dir: map (f: ./../.. + "/${dir}/${f}.nix"))
      input);
in
{

  imports = attrsToImports nixrc;

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

  # Fix trackpad on resume
  powerManagement.resumeCommands = ''
    rmmod elan_i2c
    modprobe elan_i2c
  '';

  # Add some software
  environment.systemPackages = with pkgs; [
    libreoffice
  ];

  # Compile kernel with opregion support
  nixpkgs.config.packageOverrides = before: {
    linux_latest = before.linux_latest.override {
      structuredExtraConfig = with lib.kernel; {
        I2C = yes;
        "ACPI_I2C_OPREGION" = yes;
      };
    };
  };

  system.stateVersion = "20.09";
}

