{ pkgs, ... }:

{
  home.packages = with pkgs; [ pwgen xkcdpass zbar ];

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
        PASSWORD_STORE_DIR = "$HOME/Sync/.password-store"; 
      }; 
    };

    browserpass = {
      enable = true;
      browsers = [ "chromium" "firefox" ];
    };
  };
}
