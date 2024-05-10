{ pkgs, ... }:

{
  home.packages = [
    pkgs.libnotify
  ];

  services.mako = {
    enable = true;
    defaultTimeout = 30000;
    margin = "20";
  };
}
