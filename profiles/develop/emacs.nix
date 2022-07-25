{ config, pkgs, inputs, ... }:

let
  emacsPkgs = inputs.emacs-overlay.packages.${pkgs.system};
in {
  # Enable Emacs
  services.emacs = {
    enable = true;
    package = emacsPkgs.emacsPgtkNativeComp;
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

    python3Packages.python-lsp-server
    python3Packages.pyls-isort
    #python3Packages.pyls-mypy
    #python3Packages.pyls-black

    solargraph

    csslint # replace with stylelint?
  ];
}
