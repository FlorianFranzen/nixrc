{

  programs.ssh = {
    enable = true;
    
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
    	controlMaster = "auto";
    	controlPersist = "10m";
      };
      "fawkes.local" = {
        hostname = "10.64.0.10";
        forwardAgent = true;
      };
    };
  };
}
