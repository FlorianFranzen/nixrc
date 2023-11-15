{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;

    package = pkgs.swaylock-effects;

    settings = {
      indicator-radius = 100;
      indicator-thickness = 5;

      ignore-empty-password = true;
      indicator-caps-lock = true;

      screenshots = true;

      indicator = true;
      clock = true;
      datestr = "%a, %F";

      fade-in = 1;
      effect-blur = "5x2";
    };
  };
}
