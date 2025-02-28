{ pkgs, ... }:

{
  programs.plasma.hotkeys.commands = {
    launch-foot = {
      key = "Meta+Return";
      command = "${pkgs.foot}/bin/foot";
    };
    launch-emacs = {
      key = "Meta+Shift+Return";
      command = "${pkgs.emacs29-pgtk}/bin/emacs";
    };
    launch-emacsclient = {
      key = "Meta+Alt+Return";
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
    launch-chromium = {
      key = "Meta+Alt+Backspace";
      command = "${pkgs.ungoogled-chromium}/bin/chromium --private-window";
    };
  };
}
