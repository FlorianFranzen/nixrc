{ options, lib, ... }:

{
  # Firefox keeps its system theme: it follows the colour scheme preference
  # noctalia sets and takes its colours from the gtk theme, like every other
  # gtk app; no catppuccin theme forced on top
  catppuccin.firefox.enable = lib.mkIf (options.catppuccin ? firefox) (lib.mkForce false);
}
