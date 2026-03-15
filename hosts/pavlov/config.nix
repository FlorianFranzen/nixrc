{ config, pkgs, profiles, homes, ... }:

{
  imports = (with profiles.develop; [ minimal cross linux ])
         ++ (with profiles.hardware; [ 
           common-cpu-intel
           common-gpu-intel
           common-gpu-nvidia-kepler
           common-pc-ssd
         ]);

  # Provided updated cpu microcode and basic firmwares
  hardware.cpu.intel.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Use legacy drive to support old kepler card
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  nixpkgs.config.nvidia.acceptLicense = true;

  # Install terminal environment
  home-manager.users.florian = homes.terminal-pop;
 
  # Allow suspend via power button
  services.logind.settings.Login.HandlePowerKey = "suspend";

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "25.11";
}
