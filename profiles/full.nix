{ config, pkgs, ... }:

{
  # Full is a combination of:
  imports = [ 
    ./minimal.nix
    ./desktop.nix
    ./media.nix
    ./mail.nix
    ./office.nix
  ];
}
