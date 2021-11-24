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
      };

      initExtra = ''
        source ${./zsh.p10k.sh}
      '';

      shellAliases = {
        cat = "bat --plain";

        sm = "TERM=xterm te";
        sv = "spacevim";

        incognito = "unset HISTFILE && echo 'History has been disabled.'";

        nixos-env = "sudo nix-env -p /nix/var/nix/profiles/system";
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
