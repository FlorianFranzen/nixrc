{ config, pkgs, ... }:

let
  binpath = pkg: binpath' pkg pkg.pname;
  binpath' = pkg: bin: "${pkg}/bin/${bin}";

  editor = config.programs.emacs.package;
in {
  programs.plasma.hotkeys.commands = {
    launch-emacs = {
      key = "Meta+Shift+Return";
      command = binpath' editor "emacs";
    };
    launch-emacsclient = {
      key = "Meta+Alt+Return";
      command = "${binpath' editor "emacsclient"} --create-frame";
    };
  };
}
