# Pipeline builder + binary cache role (phase 3: build/status/cache only —
# promotion, signing and the deploy key arrive with phase 4).
{ ... }:

{
  ftl.builder = {
    enable = true;

    # Phase 4: set promote = true once the builder smartcard and deploy key
    # are provisioned (signing.format = "openpgp" with the card, or "ssh"
    # with a file key; see ftl README for the bootstrap commands).
    promote = false;
    signing.format = "none";

    cache = {
      publicKey = "pavlov-1:6S3Kv1gWT/xoWcm0cRyz91M8JeGoD0oCD+T0SfamjVM=";
    };

    repos.nixrc = {
      url = "https://github.com/FlorianFranzen/nixrc.git";
      branch = "ftl";
      keepGenerations = 5;
      lanes = {
        nixpkgs = {
          inputs = [
            "nixpkgs"
            "hardware"
          ];
          schedule = "daily";
        };
        aux = {
          inputs = [
            "home-manager"
            "doom-emacs"
            "plasma-manager"
            "firefox-addons"
            "catppuccin"
          ];
          schedule = "weekly";
        };
      };
    };

    # Remote build power behind a toggle: flip enable once the ftl-build
    # user and ssh key exist on fawkes.
    remoteBuilders.fawkes = {
      enable = false;
      hostName = "fawkes";
      sshUser = "ftl-build";
      sshKey = "/var/lib/ftl/keys/fawkes-build";
      maxJobs = 8;
      speedFactor = 4;
    };
  };

  ftl.cache = {
    enable = true;
    port = 8080;
  };
}
