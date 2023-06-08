{ config, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";

    mirroredBoots = [{
      devices = [ "/dev/disk/by-uuid/19E4-40FD" ];
      path = "/boot-mirror"; 
    }];
  };

  boot.kernelParams = [ "amd_pstate=passive" ]; 

  boot.supportedFilesystems = [ "zfs" ];
}
