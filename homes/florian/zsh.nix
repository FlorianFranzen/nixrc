{ pkgs, ... }:

{
  programs = {
    # Basic tools
    bat.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    # Shell config
    zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableCompletion = true;
      #enableSyntaxHighlighting = true;

      defaultKeymap = "viins";

      localVariables = {
        # Use default powerlevel config for now
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
      };

      plugins = [
        {
          name = "powerlevel10k";
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          src = pkgs.zsh-powerlevel10k;
        }
      ];

      shellAliases = {
        cat = "bat --plain";
      };
    };
  };
}
