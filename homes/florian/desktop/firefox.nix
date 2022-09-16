{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      cfg = {
        enableBrowserpass = true;
        enableTridactylNative = true;
      };
    };

    extensions = with pkgs.firefox-addons; [
      multi-account-containers
      simple-tab-groups
      tab-stash
      browserpass
      tridactyl
      ublock-origin
      privacy-badger
      decentraleyes
      clearurls
      ipfs-companion
      polkadot-js
      metamask
    ];

    profiles.default = {
      # TODO https://github.com/arkenfox/user.js
      settings = {
        "browser.aboutConfig.showWarning" = false;

        "browser.contentblocking.category" = "strict";

        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        "browser.sessionstore.warnOnQuit" = true;

        "browser.startup.page" = 3;

        "datareporting.healthreport.uploadEnabled" = false;

        "dom.security.https_only_mode" = true;

        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;

        "media.ffmpeg.vaapi.enabled" = "true";

        "permissions.fullscreen.allowed" = true;

        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "privacy.webrtc.legacyGlobalIndicator" = false;

        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;

        "svg.context-properties.content.enabled" = true;
      };
    };
  };
}
