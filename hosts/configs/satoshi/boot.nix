{ config, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";

    mirroredBoots = [{
      devices = [ "/dev/disk/by-uuid/30B5-0E4E" ];
      path = "/boot-mirror";
    }];
  };
}
