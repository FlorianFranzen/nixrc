{

  programs.ssh = {
    enable = true;
    matchBlocks = {
      specteam-nix = {
        hostname = "specteam-nix.w3f.tech";
        user = "admin";
        forwardAgent = true;
      };
    };
  };
}
