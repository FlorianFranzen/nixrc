{ pkgs, ... }:

{
  # Collection of random software waiting for proper integration
  home.packages = with pkgs; [
    ghex
    librewolf
    ungoogled-chromium
    nextcloud-client
  ];
}
