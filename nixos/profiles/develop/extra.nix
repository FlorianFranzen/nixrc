{ config, pkgs, username, ... }:

{
  # Enable keybase
  #services.keybase.enable = true;

  # Enable ccache
  programs.ccache.enable = true;

  # Replace command-not-found with nix-index
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    nil
    nixfmt-rfc-style
    nix-diff
    nix-du
    nix-index
    nix-prefetch
    nix-top
    nix-tree
    nix-query-tree-viewer

    nixpkgs-fmt
    nixpkgs-review

    glxinfo

    gitAndTools.git-extras
    gitAndTools.git-filter-repo
    gitAndTools.git-gone
    gitAndTools.git-ignore
    git-lfs

    github-cli
    glab

    sccache
    gdb

    python3
    jupyter
    python3Packages.ipython

    binwalk
    python3Packages.base58
    wabt

    hugo

    sshfs
    encfs
    ntfs3g

    neofetch

    nmap

    keybase-gui
    zeal-qt6
  ];

  users.extraUsers.${username}.extraGroups = [ "dialout" ];
}
