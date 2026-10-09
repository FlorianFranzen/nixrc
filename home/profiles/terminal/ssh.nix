{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPersist = "10m";
      };
    };
  };
}
