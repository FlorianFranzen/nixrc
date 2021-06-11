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

    python3Packages.python-language-server
    python3Packages.pyls-isort
    python3Packages.pyls-mypy
    python3Packages.pyls-black

    csslint # replace with stylelint?
  ];
}
