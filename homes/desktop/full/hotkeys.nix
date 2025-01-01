{ pkgs, ... }:

{
  programs.plasma.hotkeys.commands = {
    launch-foot = {
      key = "Meta+Enter";
      command = "${pkgs.foot}/bin/foot";
    };
    launch-emacs = {
      key = "Meta+Shift+Enter";
      command = "${pkgs.emacs29-pgtk}/bin/emacs";
    };
    launch-emacsclient = {
      key = "Meta+Alt+Enter";
      command = "${pkgs.emacs29-pgtk}/bin/emacsclient --create-frame";
    };
    launch-firefox = {
      key = "Meta+Backspace";
      command = "${pkgs.firefox}/bin/firefox";
    };
    launch-firefox-private = {
      key = "Meta+Shift+Backspace";
      command = "${pkgs.firefox}/bin/firefox --private-window";
    };
  };
}
