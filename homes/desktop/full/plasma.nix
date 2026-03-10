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
          a6925f48-0b82-4d0b-abeb-0083dc297644 = "Personal";
          c7b31b6e-2a02-4194-8aec-3fa8c9e194ba = "Coding";
          e9db2b5d-a51c-44d6-873e-68afac1f2c4a = "Research";
        };
        activities-icons = {
	  a6925f48-0b82-4d0b-abeb-0083dc297644 = "preferences-desktop-personal";
	  c7b31b6e-2a02-4194-8aec-3fa8c9e194ba = "development";
	  e9db2b5d-a51c-44d6-873e-68afac1f2c4a = "search";
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
        # Dim inactive windows
        Effect-diminactive = {
          DimFullScreen = false;
          Strength = 10;
        };

        # Per-type translucency
        Effect-translucency = {
          ComboboxPopups = 96;
          Dialogs = 96;
          Inactive = 94;
          Menus = 96;
          MoveResize = 92;
        };

        # Max resize wobbles
        Effect-wobblywindows = {
          Drag = 97;
          MoveFactor = 25;
          Stiffness = 1;
          WobblynessLevel = 4;
        };

        # Disable odd binding
        MouseBindings.DoubleClickBorderToMaximize = false;

        # Enable night lights
        NightColor.Active = true;

        # Enable various plugins
        Plugins = {
          # Blur transparent background
          blurEnabled = true;
          # Inactive dimmed windows
          diminactiveEnabled = true;
          # Explode closed windows
          fallapartEnabled = true;
          # Tiling manager
          krohnkiteEnabled = true;
          # Smooth modal dialogs
          sheetEnabled = true;
          # Slide overlaps
          slidebackEnabled = true;
          # Translucency
          translucencyEnabled = true;
          # Wobbly animation
          wobblywindowsEnabled = true;
        };

        # Configure krohnkite
        Script-krohnkite = {
          enableBTreeLayout = true;
          enableFloatingLayout = true;
          enableQuarterLayout = true;
          enableStackedLayout = true;

          screenGapBetween = 20;
          screenGapBottom = 20;
          screenGapLeft = 20;
          screenGapRight = 20;
          screenGapTop = 20;
          tileLayoutGap = 40;
        };

        # Window switcher across activities
        TabBox = {
          DesktopMode = 0;
          LayoutName = "thumbnail_grid";
          OrderMinimizedMode = 1;
        };

        # Alt windows switcher across all
        TabBoxAlternative = {
          ActivitiesMode = 0;
          DesktopMode = 0;
          HighlightWindows = false;
          LayoutName = "flipswitch";
          OrderMinimizedMode = 1;
        };
      };

      # Enable compose key
      kxkbrc.Layout = {
        Options = "compose:ralt";
        ResetOldOptions = true;
      };

      # Use proper locals
      plasma-localerc.Formats.LANG = "en_US.UTF-8";
    };
  };
}
