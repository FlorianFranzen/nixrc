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

  # Useful fonts for development
  fonts.fonts = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    emacs-all-the-icons-fonts
  ];

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    cachix
    nixopsUnstable
    patchelf

    libfaketime

    git-crypt

    editorconfig-core-c
    direnv

    moreutils
    bat
    dos2unix
    fd
    fzf
    jq
    lsd
    ripgrep
    ncdu
    tldr
    yq
  ];
}
