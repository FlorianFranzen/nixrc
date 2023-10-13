{ config, pkgs, lib, ... }:

{
  # Enable lorri build
  services.lorri.enable = true;

  systemd.user.services.lorri.serviceConfig = {
    ProtectHome = lib.mkForce "no";
  };

  # Enable missing command indexing
  programs.command-not-found.enable = true;

  # Helper to run precompiled binaries
  programs.nix-ld.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    cachix
    direnv
    dos2unix
    fd
    fzf
    git-crypt
    gnumake
    hexyl
    jq
    libfaketime
    linux-manual
    moreutils
    ncdu
    patchelf
    ripgrep
    socat
    tree
    tldr
  ];
}
