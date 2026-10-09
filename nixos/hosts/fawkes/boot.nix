{ config, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";

    # Write copy of boot loader to second ssd of mirror
    mirroredBoots = [{
      devices = [ "/dev/disk/by-uuid/4F0A-FB18" ];
      path = "/boot-mirror"; 
    }];
  };
}
