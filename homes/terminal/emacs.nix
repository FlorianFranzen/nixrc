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
    # Special wayland friendly version
    package = lib.mkDefault pkgs.emacs29-pgtk;
  };

  # Setup emacs ...
  services.emacs = {
    # ... via local emacs server ...
    enable = true;

    # ... to be used by default
    client.enable = true;
    defaultEditor = true;

    # Use same package for server
    package = lib.mkDefault pkgs.emacs29-pgtk;

    # Only autostart in graphical session ...
    startWithUserSession = "graphical";

    # ... otherwise socket activate
    socketActivation.enable = true;
  };

  # Provide server with access to user ssh auth socket
  systemd.user.services.emacs.Service.Environment = "SSH_AUTH_SOCK=/run/user/%U/gnupg/S.gpg-agent.ssh";
}
