# The NixOS side of the noctalia desktop: the umbriel compositor, see
# nixos/profiles/desktops/umbriel.nix.  The greeter stays the host's choice.
{ profiles, ... }:
{
  imports = [ profiles.desktops.umbriel ];
}
