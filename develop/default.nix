{ config, pkgs, ... }:

{  
  # Enable Emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };

  # Enable lorri build  
  services.lorri.enable = true;

  # Enable missing command indexing
  programs.command-not-found.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
     cachix
     nixopsUnstable
     patchelf

     libfaketime

     git-crypt

     direnv

     bat
     dos2unix
     fd
     fzf
     jq
     lsd
     ripgrep
     tldr
     yq
  ];
}
