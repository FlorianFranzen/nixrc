# The NixOS side of the KDE desktop: a host that gives a user this home gets
# it, see nixos/profiles/desktops/kde.nix.  The display manager stays the
# host's choice.
{ profiles, ... }:
{
  imports = [ profiles.desktops.kde ];
}
