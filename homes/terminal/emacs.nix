{ config, pkgs, lib, self, ... }:

{
  # Install various dependencies
  home.packages = with pkgs; [
    editorconfig-core-c
    emacs-all-the-icons-fonts
  ];

  # Include unmanaged doom in path
  home.sessionPath = [ "$HOME/.config/emacs/bin" ];

  # Setups regular emacs while doom is unmanaged  
  programs.emacs = {
    enable = true;
    # Do not include any ui toolkit by default
    package = lib.mkDefault pkgs.emacs29-nox;
  };
}
