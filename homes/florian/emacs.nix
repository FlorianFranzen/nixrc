{ config, pkgs, inputs, self, ... }:

let
  emacsPkgs = inputs.emacs-overlay.packages.${pkgs.system};
in {
  # Install various dependencies
  home.packages = with pkgs; [ 
    editorconfig-core-c
  ];

  # Enable doom framework
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = "${self}/emacs";

    emacsPackage = emacsPkgs.emacsPgtk;
  };

  # Enable emacs server
  services.emacs = {
    # Use local emacs server
    enable = true;
    client.enable = true;
    #defaultEditor = true;

    # Only autostart in graphical session, otherwise socket activate
    startWithUserSession = "graphical";
    socketActivation.enable = true;
  };

  # Provide server with access to user ssh auth socket
  systemd.user.services.emacs.Service.Environment = "SSH_AUTH_SOCK=/run/user/%U/gnupg/S.gpg-agent.ssh";
}



