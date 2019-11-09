{ config, pkgs, ... }:

{  
  # Limit unfree software to developer machines
  nixpkgs.config.allowUnfree = true;  
 
  # Useful packages for development
  environment.systemPackages = with pkgs; [
     nixops
     nox
     nix-prefetch-scripts
     nix-index
#     cachix
     patchelf
#    lorri
#    niv
    
     libfaketime
     glxinfo
     
     stress
     s-tui

     direnv
     git-lfs
     
     sshfs
     encfs
     ntfs3g

     du-dust
     exa

     bat
     fd
     fzf
     ripgrep

     vimHugeX 
     zeal

     openscad
     librecad
#     freecad
     kicad 
  ];
 
  # Enable Emacs
  services.emacs.enable = true;

  # Enable keybase
  services.keybase.enable = true;

  users.extraUsers.florian = {
    extraGroups = [ "dialout" ]; 
  };
}
