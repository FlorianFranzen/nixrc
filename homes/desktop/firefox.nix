{ pkgs, ... }:

{
  home.packages = [ pkgs.filezilla ];

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = with pkgs; [
        browserpass
        kdePackages.plasma-browser-integration
        tridactyl-native
      ];
    };

    policies = {
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        Labs = false;
        Locked = true;
      };
      DisablePocket = true;
      DisableTelemetry = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableMasterPasswordCreation = true;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      OfferToSaveLogins = false;
      NoDefaultBookmarks = true;
      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      SearchSuggestEnabled = true;
      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      PictureInPicture = true;
      HardwareAcceleration = true;
    };

    profiles.default = {
      extensions.packages = with pkgs.firefox-addons; [
        browserpass
        canvasblocker
        clearurls
        decentraleyes
        mailvelope
        metamask
        multi-account-containers
        polkadot-js
        simple-tab-groups
        sponsorblock
        tab-stash
        tridactyl
        ublock-origin
        #unhook
      ];

      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" "wikipedia" ];
      };

      # TODO https://github.com/arkenfox/user.js
      settings = {
        "browser.aboutConfig.showWarning" = false;

        "browser.contentblocking.category" = "strict";

        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        "browser.sessionstore.warnOnQuit" = true;

        "browser.startup.page" = 3;

        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;

        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;

        "dom.security.https_only_mode" = true;
        "dom.webgpu.enabled" = true;

        "general.smoothScroll" = true;

        "loop.enabled" = false;

        "media.eme.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        "permissions.fullscreen.allowed" = true;

        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "privacy.webrtc.legacyGlobalIndicator" = false;

        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;

        "svg.context-properties.content.enabled" = true;

        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;

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
