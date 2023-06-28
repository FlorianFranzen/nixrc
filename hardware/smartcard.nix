{ lib, config, pkgs, ... }:

{
  # Add gpg smartcard udev rules
  hardware.gpgSmartcards.enable = true;

  # Add nitrokey udev rules
  hardware.nitrokey.enable = true;

  # Add yubikey and solo2 udev rules
  services.udev.packages = with pkgs; [
    yubikey-personalization
    solo2-cli
  ];

  # Install command line utility
  environment.systemPackages = with pkgs; [
    pynitrokey
    solo2-cli
    yubikey-manager
  ];

  # Disable ssh agent by default to give users the choice
  programs.ssh.startAgent = lib.mkDefault false;

  # Enable SmartCard daemon
  services.pcscd.enable = true;
}
