{ lib, config, pkgs, ... }:

{
  # Add gpg smartcard udev rules
  hardware.gpgSmartcards.enable = true;

  # Add nitrokey udev rules
  hardware.nitrokey.enable = true;

  # Add yubikey udev rules
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Install command line utility
  environment.systemPackages = with pkgs; [
    pynitrokey yubikey-manager
  ];

  # Disable ssh agent by default to give users the choice
  programs.ssh.startAgent = lib.mkDefault false;

  # Enable SmartCard daemon
  services.pcscd.enable = true;
}
