{ config, pkgs, lib, profiles, ...}:

{
  imports =
    (with profiles; [ corp gaming laptop media mail office podman ]) ++
    (with profiles.desktops; [ noctalia-greeter ]) ++
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
      pipewire
      rocm
      secure-boot
      smartcard
      wooting
      zsa
    ]);


  # Enable system theming
  catppuccin.enable = true;
  catppuccin.autoEnable = true;

  boot = {
    # Up-to-date kernel with better responsiveness
    kernelPackages = pkgs.linuxPackages_latest;

    # Allow access to cpu power information
    extraModulePackages = [ pkgs.linuxPackages_latest.zenergy ];

    # Support cpu and mainboard sensors
    kernelModules = [ "kvm-amd" "zenergy" ];

    # Disable panel replay in addition to PSR (0x10 from nixos-hardware),
    # DMCUB hangs in dmub_replay_get_state freeze the display otherwise.
    # Appended last so it overrides the upstream value on the cmdline.
    kernelParams = lib.mkAfter [ "amdgpu.dcdebugmask=0x410" ];
  };

  # Enables DHCP on each ethernet and wireless interface. 
  networking.useDHCP = lib.mkDefault true;

  # Enable microcode updates
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Enable input module support
  hardware.inputmodule.enable = true;

  # Install input module programs
  environment.systemPackages = with pkgs; [
    led-battery-monitor
  ];

  # Enable firmware update service
  services.fwupd.enable = true;

  # Enable CPU powersaving
  services.auto-epp.enable = true;

  # Disable default power button binding
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Unlock full performance and power management
  programs.corectrl = {
    enable = true;
    #gpuOverclock.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };
}
