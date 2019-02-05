{ config, pkgs, ... }:

{
  # Enable waybar sway support
  nixpkgs.config.packageOverrides = pkgs: {
    waybar = pkgs.waybar.override {
      pulseSupport = true;
      swaySupport = true;
    };
  };

  # Install sway
  programs.sway-beta = {
    enable = true;
    extraPackages = with pkgs; [ 
      xwayland
      kitty
      light
      mako
      #waybar # Not in unstable yet...
      rofi
    ];
  };

  # Give main user access
  users.extraUsers.florian = {
    extraGroups = [ "sway" ];
  };
}
