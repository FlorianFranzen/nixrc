{ config, pkgs, lib, ... }:

{
  # Enable missing command indexing
  programs.command-not-found.enable = true;

  # Helper to run precompiled binaries
  programs.nix-ld.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    cachix
    comma
    direnv
    dos2unix
    fd
    fzf
    git-crypt
    gnumake
    hexyl
    hydra-check
    jq
    libfaketime
    moreutils
    ncdu
    nix-output-monitor
    patchelf
    ripgrep
    socat
    tree
    tldr
  ];
}
