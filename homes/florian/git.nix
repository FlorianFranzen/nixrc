{
  programs.git = {
    enable = true;

    userEmail = "Florian.Franzen@gmail.com";
    userName = "Florian Franzen";

    delta.enable = true;

    extraConfig = {
      init.defaultBranch = "main";

      status.submoduleSummary = true;

      pull.rebase = "preserve";

      push.default = "simple";

      rebase = {
        autoStash = true;
        autoSquash = true;
      };

      diff = {
        colorMoved = "default";
        submodule = "log";
      };
    };
  };
}
