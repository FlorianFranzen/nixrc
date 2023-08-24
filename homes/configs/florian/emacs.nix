{ config, pkgs, lib, self, ... }:

{
  # Install various dependencies
  home.packages = with pkgs; [
    editorconfig-core-c
    emacs-all-the-icons-fonts
  ];
 
  # Setups regular emacs while doom is unmanaged  
  programs.emacs = {
    enable = true;
    # Special wayland friendly version
    package = lib.mkDefault pkgs.emacs29-pgtk;
  };

  # Enable emacs server
  services.emacs = {
    # Use local emacs server
    enable = true;
    client.enable = true;
    #defaultEditor = true;

    # Use same package for server
    package = lib.mkDefault pkgs.emacs29-pgtk;

    # Only autostart in graphical session, otherwise socket activate
    startWithUserSession = "graphical";
    socketActivation.enable = true;
  };

  # Provide server with access to user ssh auth socket
  systemd.user.services.emacs.Service.Environment = "SSH_AUTH_SOCK=/run/user/%U/gnupg/S.gpg-agent.ssh";
}
