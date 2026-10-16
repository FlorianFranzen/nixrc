let
  # Default headless host config
  host = name: {
    HostName = name;
    User = "admin";
    ForwardAgent = true;
  };

  # Default headless unlock config
  unlock = name: {
    HostName = name;
    Port = 2222;
    User = "root";
    ForwardAgent = false;
  };
in
{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPersist = "10m";
      };

      # denkmuskel.org infra
      "darwin darwin.denkmuskel.org" = host "darwin.denkmuskel.org";
      "turing turing.denkmuskel.org" = host "turing.denkmuskel.org";
      
      "darwin-unlock" = unlock "darwin.denkmuskel.org";
      "turing-unlock" = unlock "turing.denkmuskel.org";
      
      "legacy legacy.denkmuskel.org" = {
        HostName = "legacy.denkmuskel.org";
        User = "flo";
      };

      # gli.al infra
      "baro baro.gli.al" = host "baro.gli.al";
      "amphi amphi.gli.al" = host "amphi.gli.al";

      "baro-unlock" = unlock "baro.gli.al";
      "amphi-unlock" = unlock "amphi.gli.al";
    };
  };
}
