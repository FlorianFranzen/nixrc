{ config, pkgs, ... }:

{
  # Enable Emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };

  # Useful fonts for development
  fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts ];

  # Useful packages for development
  environment.systemPackages = with pkgs; [
    editorconfig-core-c

    cargo
    rustc
    rust-analyzer

    go
    gopls

    ccls
    cmake
    cmake-language-server

    python-language-server

    csslint # replace with stylelint?
  ];
}
