{ config, pkgs, ... }:

{  
  # Enable Emacs
  services.emacs.enable = true;

  # Enable lorri build  
  services.lorri.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
     nixops
     cachix
     patchelf
    
     libfaketime
     
     direnv
     
     bat
     lsd
     fd
     jq
     fzf
     ripgrep
  ];
}
