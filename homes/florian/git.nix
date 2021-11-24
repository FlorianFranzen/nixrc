{
  programs.git = {
    enable = true;

    userEmail = "Florian.Franzen@gmail.com";
    userName = "Florian Franzen";

    delta.enable = true;

    aliases = {
      lg = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };

    extraConfig = {
      diff = {
        colorMoved = "default";
        submodule = "log";
      };

      fetch.prune = true;

      init.defaultBranch = "main";

      pull.rebase = true;

      push.default = "simple";

      rebase = {
        autoStash = true;
        autoSquash = true;
      };

      status.submoduleSummary = true;
    };
  };
}
