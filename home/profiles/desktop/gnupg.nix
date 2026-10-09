{ pkgs, ... }:

{
  home.packages = [ pkgs.sequoia-sq ];

  programs.gpg = {
    enable = true;    

    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
  };
}
