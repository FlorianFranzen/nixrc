{ config, pkgs, ... }:

{
  # Useful packages for development
  environment.systemPackages = with pkgs; [
     nixops
     nox
     nix-prefetch-scripts
     nix-index
#     cachix
     patchelf
    
     libfaketime
     glxinfo
     
     stress
     s-tui
     
     git-lfs
     
     sshfs
     encfs
     ntfs3g

     ripgrep
     fzf

     vimHugeX 
     zeal

     openscad
     librecad
     freecad
     kicad 

     virtmanager
     spice-gtk
  ];
 
  # Enable Emacs
  services.emacs.enable = true;

  # Enable keybase
  services.keybase.enable = true;

  # Container and virtualization
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  security.wrappers.spice-client-glib-usb-acl-helper.source =
    "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  users.extraUsers.florian = {
    extraGroups = [ "docker" "libvirtd" ]; 
  };
}
