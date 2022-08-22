{ lib, config, pkgs, ... }:

{
  # Add smartcard udev rules
  hardware.gpgSmartcards.enable = true;

  # Install command line utility
  environment.systemPackages = with pkgs; [
    yubikey-manager
  ];

  # Disable ssh agent by default to give users the choice
  programs.ssh.startAgent = lib.mkDefault false;

  # Give user access to yubikey hardware
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enable SmartCard support
  services.pcscd.enable = true;
}
