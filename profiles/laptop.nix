{ lib, ... }:

{
  # Enable backlight control
  programs.light.enable = true;

  # Enable bluetooh manager
  services.blueman.enable = true;

  security.polkit.extraConfig = ''
    /* Allow users in wheel group to use blueman feature requiring root without authentication */
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.blueman.network.setup" ||
           action.id == "org.blueman.dhcp.client" ||
           action.id == "org.blueman.rfkill.setstate" ||
           action.id == "org.blueman.pppd.pppconnect") &&
           subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Enable power management
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };
}
