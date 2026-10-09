{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ pwgen wofi-pass xkcdpass zbar ];

  programs = {
    password-store = {
      enable = true;
      package = pkgs.pass-wayland.withExtensions (exts: [
        exts.pass-audit
        exts.pass-genphrase
        exts.pass-otp
        exts.pass-update
      ]);
      settings = { 
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        PASSWORD_STORE_GENERATED_LENGTH = "32";
        PASS_FIELD_USERNAME = "login";
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "chromium" "firefox" ];
    };
  };

  services.pass-secret-service = {
    enable = true;
    storePath = "${config.xdg.dataHome}/password-store";
  };
}
