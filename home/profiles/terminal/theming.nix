{ config, lib, ... }:

let
  theme = config.theme;
in
{
  config = lib.mkIf theme.enable {
    # Theme command line tools
    programs.bat.config.theme = lib.mkIf (theme.bat != null) theme.bat;
    programs.broot.settings.imports = lib.mkIf (theme.broot != null) [ theme.broot ];

    # Catppuccin ships its own modules for most tools
    catppuccin = lib.mkIf (theme.catppuccin != null) {
      enable = true;
      autoEnable = true;
      inherit (theme.catppuccin) flavor accent;
    };

    # Terminal colour sequences, emitted by zsh over ssh (see zsh.nix); on
    # noctalia hosts the shell renders this file itself
    xdg.configFile = {
      "zsh/sequences" = lib.mkIf (theme.managedBy == "nix") { text = theme.sequences.dark; };
      "zsh/sequences-reset".text = theme.sequences.reset;
    };
  };
}
