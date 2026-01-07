{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.kdePackages.krohnkite ];

  programs.plasma = {
    enable = true;

    overrideConfig = true;

    krunner.position = "center";

    kwin.virtualDesktops = {
      number = 8;
      rows = 2;
    };

    configFile = {
      # Disable baloo for now
      baloofilerc = {
        "Basic Settings"."Indexing-Enabled" = false;
        "General"."only basic indexing" = true;
      };

      # Define activities
      kactivitymanagerdrc = {
        activities = {
          a6925f48-0b82-4d0b-abeb-0083dc297644 = "Coding";
          c7b31b6e-2a02-4194-8aec-3fa8c9e194ba = "Personal";
          e9db2b5d-a51c-44d6-873e-68afac1f2c4a = "Research";
        };
        main.currentActivity = "a6925f48-0b82-4d0b-abeb-0083dc297644";
      };

      # Define default applications
      kdeglobals.General = {
        TerminalApplication = "foot";
        TerminalService = "org.codeberg.dnkl.foot.desktop";
      };

      # Disable session restore
      ksmserverrc.General.loginMode = "emptySession";

      kwinrc = {
        # Enable night lights
        NightColor.Active = true;

        # Enable and configure krohnkite
        Plugins.krohnkiteEnabled = true;

        Script-krohnkite = {
          enableBTreeLayout = true;
          enableFloatingLayout = true;
          enableQuarterLayout = true;
          enableStackedLayout = true;

          screenGapBottom = 20;
          screenGapLeft = 20;
          screenGapRight = 20;
          screenGapTop = 20;
          tileLayoutGap = 20;
        };
      };

      # Enable compose key
      kxkbrc.Layout.Options = "compose:ralt";

      # Use proper locals
      plasma-localerc.Formats.LANG = "en_US.UTF-8";
    };
  };
}
