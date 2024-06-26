{ lib, ... }:

{
  programs.git = {
    enable = true;

    userEmail = "Florian.Franzen@gmail.com";
    userName = "Florian Franzen";

    difftastic = {
      enable = true;
      background = lib.mkDefault "dark";
    };

    aliases = {
      lg = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };

    extraConfig = {
      advice.skippedCherryPicks = false;

      bitbucket.user = "FlorianFranzen";

      diff = {
        colorMoved = "default";
        submodule = "log";
      };

      fetch.prune = true;

      github.user = "FlorianFranzen";
      gitlab.user = "FlorianFranzen";

      init.defaultBranch = "main";

      pull.rebase = true;

      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      rebase = {
        autoStash = true;
        autoSquash = true;
      };

      status.submoduleSummary = true;
    };
  };
}
