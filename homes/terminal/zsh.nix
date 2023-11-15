{ pkgs, lib, ... }:

{
  programs = {
    # Basic tools
    bat.enable = true;

    broot = {
      enable = true;
      settings.default_flags = "gh";
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    # Enable direnv with nix integration
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Shell config
    zsh = {
      enable = true;

      defaultKeymap = "viins";

      localVariables = {
        # Set additional defaults
        BROWSER = "firefox";
      };

      initExtra = ''
        # Load color scheme
        [[ -f ~/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)

        # Load powerlevel10k config
        source ${./zsh.p10k.sh}
      '';

      shellAliases = {
        cat = "bat --plain";

        e = "emacsclient --reuse-frame --no-wait";
        te = "emacsclient --tty";

        incognito = "unset HISTFILE && echo 'History has been disabled.'";

        nixos-env = "sudo nix-env -p /nix/var/nix/profiles/system";

        tree = "lsd --tree";
      };

      # Configure plugins
      enableAutosuggestions = true;
      enableCompletion = true;
      #enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "systemd" ];
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
