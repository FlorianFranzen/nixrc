{ pkgs, ... }: 

{
  boot = { 
    # Some extra hardware modules needed for nvme boot
    initrd.availableKernelModules = [ "pcie_rockchip_host" "phy_rockchip_pcie" "nvme" ];
    
    loader = {   
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
    
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };

    # Use newer kernels to avoid hardware problems
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
