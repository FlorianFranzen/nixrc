{ pkgs, ... }:

{
  # Support printing on home printer
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-brother-mfcl2710dw ];
  };

  # Support scanning on home printer
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices.gutenberg = {
        nodename = "gutenberg.fritz.box";
        model = "MFC-L2710DW";
      };
    };
  };

  # Give default user scanner access
  users.extraUsers.florian.extraGroups = [ "scanner" ];
}
