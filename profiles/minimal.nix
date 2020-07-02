# Base config for all hosts

{ config, pkgs, ... }:

{
  # Enable intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Enable flake support
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select login console setup
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    binutils
    pciutils
    usbutils
    acpitool

    psmisc
    lsof
    htop
    iftop

    bind

    vim
    file
    git
    gnupg
    p7zip
    tree
  ];

  # Enable base programs
  programs = {
    tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
    };

    mtr.enable = true;

    zsh = { 
      enable = true;
      enableGlobalCompInit = false;
    };
  };

  # Enable SSH login via key
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  security.pam.enableSSHAgentAuth = true;

  # Enable time synchronization
  services.ntp.enable = true;

  # Add default users
  users.users.florian = {
    isNormalUser = true;
    description = "Florian Franzen";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXZ+XdLV1D5NqKCqY/PU2ntCm1v7zwtBXEK6px12E04d4lS6fjnbJ+bEaw1GtHI/KMhz+rmFRVVGd/gjONtGJ6BCxHelHcuw0/sCvuuwYk8WkdSRD7nZ5CEJt+xiyqcUC4uzCd9woR/+i7vfNTabPvx1+fnlCS/+HmpViv7UiaOXxzsqHPYCOXWl3I+EiI0UGOGJoZFAnfb+7yNX0SnzCZsLZJ5s2jr5V1NqEql70d3JXQDY4uQSsbMjdsc0jopc1ICcDqK9td/WdV4votSggY0Mz6oLw3vcdp+kyIreoGiGF+1yMIc03xIRPDzrA/Y2rascImLpBBV3zZQ6rSOYPhufWs74aueVZTiv4MMIxb4R+yZs93BHEtd76wQTE+VnxXTkvA8Lb2doh3WrcdX+2tiDWUXfjNg0Ko0QNH8liY7KuoeP4hgx2iSWpHoGOhYP1006es/TgFtWo21ZHmGiuPC/mWwUjLFddbP+ERqIaGtuE+62dJZTK3inD3xQqtSivTW1ZOcViZWLhM5mFYj6Hlklboi6HbDydLi9nTat+yfF+5KOiH69HwPjtTIrfTUIndQqTZSfRi/MLPZRfxLo3UeqSPWnbJe7A56Mc3kvlQbjrNkcJTwMIeIiVbDTwtoXiMwk8Z/r/R7+9Z1r2/6uzBLPaiNNdxZ/E6EKl7ThaAHQ== cardno:000604936884"
    ];
  };
}
