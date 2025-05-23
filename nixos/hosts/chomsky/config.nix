{ config, pkgs, lib, profiles, homes, ...}:

{
  imports =
    (with profiles; [ corp gaming laptop media mail office podman ]) ++
    (with profiles.desktops; [ gdm sway ]) ++ 
    (with profiles.develop; [
      minimal
      embedded
      extra
      cross
      linux
    ]) ++ 
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      framework-16-7040-amd
      secure-boot
      pipewire
      smartcard
      wooting
      zsa
    ]);

  # Install light desktop environment
  home-manager.users.florian = homes.desktop-light-solarized;

  boot = {
    # Up-to-date kernel with better responsiveness
    kernelPackages = pkgs.linuxPackages_latest;

    # Allow access to cpu power information
    extraModulePackages = [ pkgs.linuxPackages_latest.zenergy ];

    # Support cpu and mainboard sensors
    kernelModules = [ "kvm-amd" "zenergy" ];
  };

  # Enables DHCP on each ethernet and wireless interface. 
  networking.useDHCP = lib.mkDefault true;

  # Enable microcode updates
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Enable input module support
  hardware.inputmodule.enable = true;

  # Enable firmware update service
  services.fwupd.enable = true;

  # Disable default power button binding
  services.logind.extraConfig = "HandlePowerKey=ignore";

  # Make hip available at known-path
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Unlock full performance and power management
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "25.05"; 
}
