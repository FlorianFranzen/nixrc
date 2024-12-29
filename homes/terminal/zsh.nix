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
      stdlib = ''
        # Ensure cargo build cache is stored in tmp dir
        cargo_tmp_target() {
          export CARGO_TARGET_DIR="/tmp/cargo-$(basename $PWD)-$(md5sum <<< $PWD | tr -d ' -')/"
          if test ! -d $CARGO_TARGET_DIR; then mkdir $CARGO_TARGET_DIR; fi
          if test ! -e target -o -L target; then ln -sf $CARGO_TARGET_DIR target; fi
          export WASM_BUILD_WORKSPACE_HINT=$PWD
        }
      '';
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
        vim = "nvim";

        flake = "nix flake";

        incognito = "unset HISTFILE && echo 'History has been disabled.'";

        nixos-env = "sudo nix-env -p /nix/var/nix/profiles/system";

        tree = "lsd --tree";
      };

      # Configure plugins
      autosuggestion.enable = true;
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
