{ lib, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.email = "Florian.Franzen@gmail.com";
      user.name = "Florian Franzen";

      alias = {
        lg = "log --graph --decorate --pretty=oneline --abbrev-commit";
      };

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

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.background = lib.mkDefault "dark";
  };
}
