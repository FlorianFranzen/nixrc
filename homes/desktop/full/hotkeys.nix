{ config, pkgs, ... }:

let
  binpath = pkg: binpath' pkg pkg.pname;
  binpath' = pkg: bin: "${pkg}/bin/${bin}";

  browser = config.programs.firefox.package;
  editor = config.programs.emacs.package;
in {
  programs.plasma.hotkeys.commands = {
    launch-foot = {
      key = "Meta+Return";
      command = binpath pkgs.foot;
    };
    launch-emacs = {
      key = "Meta+Shift+Return";
      command = binpath' editor "emacs";
    };
    launch-emacsclient = {
      key = "Meta+Alt+Return";
      command = "${binpath' editor "emacsclient"} --create-frame";
    };
    launch-librewolf = {
      key = "Meta+Backspace";
      command = binpath browser;
    };
    launch-librewolf-private = {
      key = "Meta+Shift+Backspace";
      command = "${binpath browser} --private-window";
    };
    launch-chromium = {
      key = "Meta+Alt+Backspace";
      command = "${binpath' pkgs.ungoogled-chromium "chromium"} --private-window";
    };
  };
}
