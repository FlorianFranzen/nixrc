{ config, pkgs, ... }:

{
  # Full is a combination of:
  imports = [ 
    ./minimal.nix
    ./desktop.nix
    ./media.nix
    ./office.nix
    ./develop.nix
    ./virtual.nix
  ];
}
