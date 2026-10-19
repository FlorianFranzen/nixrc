# The NixOS side of the sway desktop, see nixos/profiles/desktops/sway.nix.
{ profiles, ... }:
{
  imports = [ profiles.desktops.sway ];
}
