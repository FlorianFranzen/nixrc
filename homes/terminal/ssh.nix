{

  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPersist = "10m";

    matchBlocks = {
      "fawkes.local" = {
        hostname = "10.64.0.10";
        forwardAgent = true;
      };
    };
  };
}
