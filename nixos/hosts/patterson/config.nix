{ profiles,  ... }:

{
  imports = with profiles; [
    develop.minimal
    services.teddycloud
  ];

  # Optimize power usage
  powerManagement.cpuFreqGovernor = "ondemand";

  # Set processor architecture
  nixpkgs.hostPlatform = "aarch64-linux";
}

