{ config, pkgs, lib,  ... }:

let
  nixrc = {
    profiles = [ "full" "docker" ];
    develop  = [ "default" "emacs" "extra" ];
    desktops = [ "lightdm" "sway" ];
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
    # Latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    # Fix backlight control
    kernelParams = [ "amdgpu.backlight=0" ];

    # Avoid nouveau failing to initialize discrete gpu
    blacklistedKernelModules = [ "nouveau" ];
  };

  # FIXME: Move to correct profile
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.05"; 
}
