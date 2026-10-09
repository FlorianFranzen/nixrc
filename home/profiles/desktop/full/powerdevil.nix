{
  programs.plasma.powerdevil = {
    AC = {
      autoSuspend.action = "nothing";

      powerButtonAction = "showLogoutScreen";
      powerProfile = "performance";

      dimDisplay = {
        enable = true;
        idleTimeout = 300;
      };

      turnOffDisplay = {
        idleTimeout = 600;
        idleTimeoutWhenLocked = 30;
      };
    };
  };
}
