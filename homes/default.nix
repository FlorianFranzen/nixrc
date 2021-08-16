{ home-manager, lib, sources }:

let
  users = [
    "florian"
  ];

  mkHome = username: home-manager.lib.homeManagerConfiguration {
    system = "x86_64-linux";

    homeDirectory = "/home/${username}";
    inherit username;

    stateVersion = "21.05";

    extraSpecialArgs = {
      inherit sources;
    };

    configuration = import (./. + "/${username}");
  };
in lib.genAttrs users mkHome
