{ ... }: 

{
  # Root filesystem, boot and swap on NVME
  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/61032b39-177e-48d6-b708-6f4f01b598d0";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/3599-BE57";
    fsType = "vfat";
  };

  swapDevices = [ 
    { device = "/dev/disk/by-uuid/3c142f56-6f1a-4a75-b68c-4e0230606621"; }
  ];
}
