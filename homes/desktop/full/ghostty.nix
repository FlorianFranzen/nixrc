{
  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      quit-after-last-window-closed = false;
      shell-integration-features = "sudo,ssh-env,ssh-terminfo,title";
    };

    systemd.enable = true;
  };
}
