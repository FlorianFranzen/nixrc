{
  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      quit-after-last-window-closed = false;
      shell-integration-features = "sudo,ssh-env,ssh-terminfo,title";

      # Bound to toggle_fullscreen by default
      keybind = [ "ctrl+enter=unbind" ];

      # Rendered by noctalia's ghostty template, reloaded on change
      theme = "noctalia";

      # Lift low contrast text, mostly the light palettes' yellow and green
      minimum-contrast = 3;
    };

    systemd.enable = true;
  };
}
