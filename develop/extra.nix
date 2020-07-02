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
     
     gitAndTools.git-extras
     gitAndTools.git-gone
     gitAndTools.git-ignore
     git-lfs
     
     sshfs
     encfs
     ntfs3g

     exa

     vimHugeX 
     zeal

     riot-desktop
     mumble
  ];


}
