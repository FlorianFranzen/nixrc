{ profiles, homes, ... }:

{
  imports = with profiles; [
    develop.minimal
    services.teddycloud
  ];

  # Terminal only home with its own colours
  home-manager.users.florian = homes.terminal-dracula;

  # Optimize power usage
  powerManagement.cpuFreqGovernor = "ondemand";

  # Set processor architecture
  nixpkgs.hostPlatform = "aarch64-linux";
}

