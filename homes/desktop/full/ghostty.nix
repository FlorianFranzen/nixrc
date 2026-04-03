{
  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      quit-after-last-window-closed = false;
    };

    systemd.enable = true;
  };
}
