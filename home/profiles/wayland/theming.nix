{ config, lib, ... }:

{
  # Use gtk theme for qt as well
  qt = {
    enable = true;
    platformTheme.name = lib.mkDefault "gtk3";
    style.name = lib.mkIf (config.theme.catppuccin != null) "kvantum";
  };
}
