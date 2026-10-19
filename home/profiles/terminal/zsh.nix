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
      enableZshIntegration = true;
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
      enableCompletion = true;

      defaultKeymap = "viins";

      # Set additional defaults
      localVariables = {
        BROWSER = "firefox";
      };

      # Over ssh paint the terminal in this host's colours, restore on exit
      initContent = ''
        if [[ -n $SSH_CONNECTION && -f ~/.config/zsh/sequences ]]; then
          command cat ~/.config/zsh/sequences
          zshexit() { command cat ~/.config/zsh/sequences-reset; }
        fi
      '';

      # Provide some additional aliases
      shellAliases = {
        evil-claude = "NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#claude-code --impure";
        cat = "bat --plain";
        ekill = "emacsclient -e '(kill-emacs)'";
        flake = "nix flake";
        incognito = "unset HISTFILE && echo 'History has been disabled.'";
        nixos-env = "sudo nix-env -p /nix/var/nix/profiles/system";
        tree = "lsd --tree";
      };

      # Configure plugins
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "emacs" "systemd" ];
      };
    };
  };
}
