{ config, pkgs, ... }:

{  
  # Enable keybase
  services.keybase.enable = true;

  # Enable ccache
  programs.ccache.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
     nix-prefetch
     nix-index
    
     glxinfo
     
     git-lfs
     
     sshfs
     encfs
     ntfs3g

     exa

     vimHugeX 
     zeal
  
     mumble
  ];


}
