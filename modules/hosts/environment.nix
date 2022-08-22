# Default package environment for all hosts
{ pkgs, ... }:

{
  environment = {
    # Optimize necessary packages in system profile
    defaultPackages = with pkgs; [
      git perl rsync strace
    ];

    # Link common completion files
    pathsToLink = [ "/share/bash" "/share/zsh" ];

    # List of useful packages in system profile.
    systemPackages = with pkgs; [
      bind
      file
      lsof
      p7zip
      psmisc
    ];
  };

  # Enable some base programs
  programs = {

    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };

    iftop.enable = true;

    tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
    };

    vim = {
      package = pkgs.vimHugeX.override { guiSupport = false; };
      defaultEditor = true;
    };

    zsh.enable = true;
  };
}	
