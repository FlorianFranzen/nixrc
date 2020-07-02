{ config, pkgs, ... }:

{  
  # Enable Emacs
  services.emacs.enable = true;

  # Enable lorri build  
  services.lorri.enable = true;

  # Enable missing command indexing
  programs.command-not-found.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
     cachix
     niv
     nixops
     patchelf
    
     libfaketime

     git-crypt
     gitAndTools.git-subrepo

     direnv
     
     bat
     fd
     fzf
     jq
     lsd
     ripgrep
     tldr
     yq
  ];
}
