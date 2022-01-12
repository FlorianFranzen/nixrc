{ config, pkgs, ... }:

{
  # Enable lorri build
  services.lorri.enable = true;

  # Enable missing command indexing
  programs.command-not-found.enable = true;

  # Useful fonts for development
  fonts.fonts = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    cachix
    direnv
    dos2unix
    fd
    fzf
    git-crypt
    gnumake
    jq
    libfaketime
    moreutils
    ncdu
    nixopsUnstable
    patchelf
    ripgrep
    socat
    tree
    tldr
    yq
  ];
}
