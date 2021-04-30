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
    gitAndTools.git-filter-repo
    gitAndTools.git-gone
    gitAndTools.git-ignore
    git-lfs

    github-cli

    sccache
    gdb

    python3
    jupyter
    python3Packages.ipython

    julia

    python3Packages.binwalk
    python3Packages.base58
    wabt

    hugo

    sshfs
    encfs
    ntfs3g

    neofetch
    exa

    nmap

    androidenv.androidPkgs_9_0.platform-tools

    vimHugeX
    keybase-gui
    zeal
  ];
}
