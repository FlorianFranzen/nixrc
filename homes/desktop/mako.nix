{ pkgs, ... }:

{
  home.packages = [
    pkgs.libnotify
  ];

  services.mako = {
    enable = true;
    borderSize = 2;
    defaultTimeout = 30000;
    margin = "20";

    extraConfig = with pkgs; ''
      on-button-middle=exec ${mako}/bin/makoctl menu -n "$id" ${wofi}/bin/wofi -dp 'Select action:'
    '';
  };
}
