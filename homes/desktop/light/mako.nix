{ pkgs, ... }:

{
  home.packages = [
    pkgs.libnotify
  ];

  services.mako = {
    enable = true;
    settings = {
      borderSize = 2;
      defaultTimeout = 30000;
      margin = 20;
      on-button-middle = with pkgs; "exec ${mako}/bin/makoctl menu -n '$id' ${wofi}/bin/wofi -dp 'Select action:'";
    };
  };
}
