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
      # HDD-backed static binary cache (nested subvolume, excluded from
      # btrbk because it is nested under @data).
      dir = "/data/cache";
      secretKeyFile = "/var/lib/ftl/keys/cache.secret";
      # nix key convert-secret-to-public < cache.secret; also referenced by
      # every client's ftl.client.substituters entry.
      # publicKey = "pavlov-1:...";
    };

    repos.nixrc = {
      url = "https://github.com/FlorianFranzen/nixrc.git";
      branch = "master";
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
    cacheDir = "/data/cache";
    port = 8080;
  };
}
