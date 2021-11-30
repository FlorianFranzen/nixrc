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
    gnumake

    cachix
    nixopsUnstable
    patchelf

    libfaketime

    git-crypt

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
