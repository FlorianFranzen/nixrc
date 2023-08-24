{ config, pkgs, ... }:

{
  # Enable keybase
  #services.keybase.enable = true;

  # Enable ccache
  programs.ccache.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    nix-diff
    nix-du
    nix-index
    nix-prefetch
    nix-top
    nix-tree

    nix-query-tree-viewer

    nixpkgs-fmt
    nixpkgs-review

    #nixopsUnstable

    glxinfo

    gitAndTools.git-extras
    gitAndTools.git-filter-repo
    gitAndTools.git-gone
    gitAndTools.git-ignore
    git-lfs
    gitoxide

    github-cli

    sccache
    gdb

    python3
    jupyter
    python3Packages.ipython

    julia_16-bin

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

    keybase-gui
    zeal-qt6
  ];

  users.extraUsers.florian.extraGroups = [ "dialout" ];
}
