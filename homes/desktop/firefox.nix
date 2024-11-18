{ pkgs, ... }:

{
  home.packages = [ pkgs.filezilla ];

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = with pkgs; [ browserpass tridactyl-native vdhcoapp kdePackages.plasma-browser-integration ];
    };

    profiles.default = {
      extensions = with pkgs.firefox-addons; [
        multi-account-containers
        tab-stash
        browserpass
        tridactyl
        ublock-origin
        privacy-badger
        decentraleyes
        clearurls
        sponsorblock
        polkadot-js
        metamask
        mailvelope
        plasma-integration
      ];

      # TODO https://github.com/arkenfox/user.js
      settings = {
        "browser.aboutConfig.showWarning" = false;

        "browser.contentblocking.category" = "strict";

        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        "browser.sessionstore.warnOnQuit" = true;

        "browser.startup.page" = 3;

        "datareporting.healthreport.uploadEnabled" = false;

        "dom.security.https_only_mode" = true;

        "media.ffmpeg.vaapi.enabled" = "true";

        "permissions.fullscreen.allowed" = true;

        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "privacy.webrtc.legacyGlobalIndicator" = false;

        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;

        "svg.context-properties.content.enabled" = true;

        "webgl.force-enabled" = true;
      };
    };
  };

  # Allow access to users gnupg environment
  home.file.".mozilla/native-messaging-hosts/gpgmejson.json".text = builtins.toJSON {
    name = "gpgmejson";
    description = "JavaScript binding for GnuPG";
    path = "${pkgs.gpgme.dev}/bin/gpgme-json";
    type = "stdio";
    allowed_extensions = [ "jid1-AQqSMBYb0a8ADg@jetpack" ];
  };
}
