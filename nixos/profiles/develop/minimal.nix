{ config, pkgs, lib, ... }:

{
  # Missing-command indexing needs the channel-only programs.sqlite, which
  # flake sources do not ship (develop/extra replaces it with nix-index)
  programs.command-not-found.enable = lib.mkDefault false;

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
