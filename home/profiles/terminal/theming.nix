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
  };
}
