{ pkgs, ... }:

let
  gnupg_patches = [
    (pkgs.fetchpatch {
      url = "https://dev.gnupg.org/rGf34b9147eb3070bce80d53febaa564164cd6c977?diff=1";
      sha256 = "sha256-J/PLSz8yiEgtGv+r3BTGTHrikV70AbbHQPo9xbjaHFE=";
    })
  ];

  gnupg = pkgs.gnupg.overrideAttrs (old: {
    patches = old.patches ++ gnupg_patches;
  }); 

in {
  home.packages = [ pkgs.sequoia ];

  programs.gpg = {
    enable = true;    
    package = gnupg;

    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };
}
