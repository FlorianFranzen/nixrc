{ profiles, ... }:

{
  imports = with profiles; [
    develop.minimal
    services.teddycloud
  ];


  # Optimize power usage
  powerManagement.cpuFreqGovernor = "ondemand";

}

