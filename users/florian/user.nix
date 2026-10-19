# Florian (ftl user metadata, not a module): an account on every host, in
# wheel, sudo through the forwarded SSH agent when there is one.  The shell
# and the description stay in nixos/modules/florian.nix.
#
# The home per host: KDE on the workstation, noctalia on the laptop,
# terminal-only elsewhere, none on hull.  The desktop profiles bring their
# NixOS side along (home/profiles/<desktop>/nixos.nix).
{
  admin = true;
  uid = 1000;
  home = {
    default = "terminal-flexoki";
    fawkes = "desktop-kde-gruvbox";
    lovelace = "desktop-noctalia-catppuccin";
    patterson = "terminal-dracula";
    pavlov = "terminal-selenized";
    hull = null;
  };
}
