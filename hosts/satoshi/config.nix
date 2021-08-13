{ config, pkgs, lib,  ... }:

let
  nixrc = {
    profiles = [ "full" "docker" "gaming" ];
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

  # Fix backlight control
  boot.kernelParams = [ "amdgpu.backlight=0' ];

  # FIXME: Move to correct profile
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.05"; 
}
