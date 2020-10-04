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
    nix-diff
    nix-top

    nixpkgs-fmt
    nixpkgs-review

    glxinfo

    gitAndTools.git-extras
    gitAndTools.git-gone
    gitAndTools.git-ignore
    git-lfs

    gdb

    python3

    hugo

    sshfs
    encfs
    ntfs3g

    neofetch
    exa

    vimHugeX
    keybase-gui
    zeal
  ];
}
