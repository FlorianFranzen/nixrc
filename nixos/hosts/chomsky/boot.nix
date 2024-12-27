{
  boot = {
    # EFI boot variables are safe to be modified
    loader.efi.canTouchEfiVariables = true;

    # Install signed bootloader to efi mirror
    lanzaboote.extraEfiSysMountPoints = [ "/boot-mirror" ];
  };
}
