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

    github-cli

    sccache
    gdb

    python3
    jupyter
    python3Packages.ipython

    python3Packages.binwalk
    wabt

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
