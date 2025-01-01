{
  programs.plasma = {
    shortcuts = {
      # Power and lock controls
      ksmserver = {
        "Lock Session" = "Meta+O";
        "Log Out" = "Meta+Shift+Q";
      };

      # Desktop and Window management
      kwin = {
        # Alerting and overviews
        "Activate Window Demanding Attention" = "Meta+S";

        ExposeClass = "Meta+G";
        ExposeAll = "Meta+Shift+G";

        # Opacity controls
        "Decrease Opacity" = "Meta+[";
        "Increase Opacity" = "Meta+]";

        # Krohnkite tiling
        KrohnkiteToggleFloat = "Meta+Space";
        KrohnkiteFloatAll = "Meta+Shift+Space";

        KrohnkiteFocusLeft = [
          "Meta+H"
          "Meta+Left"
        ];
        KrohnkiteFocusDown = [
          "Meta+J"
          "Meta+Down"
        ];
        KrohnkiteFocusUp = [
          "Meta+K"
          "Meta+Up"
        ];
        KrohnkiteFocusRight = [
          "Meta+L"
          "Meta+Right"
        ];

        KrohnkiteDecrease = "Meta+Shift+I";
        KrohnkiteIncrease = "Meta+I";

        KrohnkitePreviousLayout = "Meta+W";
        KrohnkiteNextLayout = "Meta+E";

        KrohnkiteRotate = "Meta+R";
        KrohnkiteRotatePart = "Meta+Shift+R";
        KrohnkiteSetMaster = "Meta+T";

        KrohnkiteShiftLeft = [
          "Meta+Shift+H"
          "Meta+Shift+Left"
        ];
        KrohnkiteShiftDown = [
          "Meta+Shift+J"
          "Meta+Shift+Down"
        ];
        KrohnkiteShiftUp = [
          "Meta+Shift+K"
          "Meta+Shift+Up"
        ];
        KrohnkiteShiftRight = [
          "Meta+Shift+L"
          "Meta+Shift+Right"
        ];

        # Desktop switching
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";

        # Window switching
        "Walk Through Windows" = "Meta+Tab";
        "Walk Through Windows (Reverse)" = "Meta+Shift+Tab";

        "Walk Through Windows Alternative" = "Alt+Tab";
        "Walk Through Windows Alternative (Reverse)" = "Alt+Shift+Tab";

        # Window manipulation
        "Window Close" = "Meta+Q";
        "Window Fullscreen" = "Meta+F";
        "Window Operations Menu" = "Meta+B";
        "Window Minimize" = "Meta+N";
        "Window Maximize" = "Meta+M";

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+^";
        "Window to Desktop 7" = "Meta+&";
        "Window to Desktop 8" = "Meta+*";
        "Window to Desktop 9" = "Meta+(";

        # Zoom controlls
        view_actual_size = "Meta+0";
        view_zoom_in = "Meta+=";
        view_zoom_out = "Meta+-";

        # Unbind conflicts
        "Edit Tiles" = "none";
        "Grid View" = "none";
        "Overview" = "none";
        "Show Desktop" = "none";
      };

      # Plasmashell integration
      plasmashell = {
        "next activity" = "Meta+A";
        "previous activity" = "Meta+Shift+A";
        "show-on-mouse-pos" = "Meta+V";

        # Unbind conflicts
        "stop current activity" = "none";
        "activate task manager entry 1" = "none";
        "activate task manager entry 2" = "none";
        "activate task manager entry 3" = "none";
        "activate task manager entry 4" = "none";
        "activate task manager entry 5" = "none";
        "activate task manager entry 6" = "none";
        "activate task manager entry 7" = "none";
        "activate task manager entry 8" = "none";
        "activate task manager entry 9" = "none";
        "activate task manager entry 10" = "none";
      };

      # Application launch shortcuts
      "services/org.kde.dolphin.desktop"."_launch" = "Meta+Del";
      "services/org.kde.krunner.desktop"."_launch" = "Meta+D";
    };

    spectacle.shortcuts.launch = "Meta+P";
  };
}
