{ pkgs, ... }:

{
  programs = {
    # Basic tools
    bat.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    direnv.enable = true;

    # Shell config
    zsh = {
      enable = true;

      defaultKeymap = "viins";

      localVariables = {
        # Set default 
        EDITOR = "vim";
        BROWSER = "firefox";

        # Use default powerlevel config for now
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
      };

      shellAliases = {
        cat = "bat --plain";

        sm = "TERM=xterm te";
        sv = "spacevim";

        incognito = "unset HISTFILE && echo 'History has been disabled.'";
      };

      # Configure plugins
      enableAutosuggestions = true;
      enableCompletion = true;
      #enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "emacs" "systemd" ];
      };

      plugins = [
        {
          name = "powerlevel10k";
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          src = pkgs.zsh-powerlevel10k;
        }
      ];
    };
  };
}