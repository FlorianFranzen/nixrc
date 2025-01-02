{ pkgs, ... }:

{
  home.packages = [ pkgs.kdePackages.applet-window-buttons6 ];

  programs.plasma.panels = [
    {
      alignment = "center";
      floating = true;
      height = 64;
      location = "top";
      extraSettings = ''
        var titles = panel.widgets("org.kde.windowtitle");
        for(var i = 0; i < titles.length; i++) {
          var w = titles[i];
          w.currentConfigGroup = ["Appearance"];
          w.writeConfig("customSize", 32);
          w.writeConfig("fontSize", 16);
          w.writeConfig("isBold", true);
        }
        var pagers = panel.widgets("org.kde.plasma.pager");
        for(var i = 0; i < pagers.length; i++) {
          var w = pagers[i];
          w.currentConfigGroup = ["General"];
          w.writeConfig("displayText", "Number");
          w.writeConfig("showWindowIcons", true);
        }
        var activities = panel.widgets("org.kde.plasma.activitypager");
        for(var i = 0; i < activities.length; i++) {
          var w = activities[i];
          w.currentConfigGroup = ["General"];
          w.writeConfig("displayText", "Name");
          w.writeConfig("pagerLayout", "Horizontal");
          w.writeConfig("showWindowIcons", true);
        }
        var clocks = panel.widgets("org.kde.plasma.digitalclock");
        for(var i = 0; i < clocks.length; i++) {
          var w = clocks[i];
          w.currentConfigGroup = ["Appearance"];
          w.writeConfig("dateFormat", "isoDate");
          w.writeConfig("firstDayOfWeek", 1);
          w.writeConfig("use24hFormat", 2);
        }
      '';
      widgets = [
        "org.kde.plasma.pager"
        "org.kde.plasma.icontasks"
        "org.kde.plasma.marginsseparator"
        "org.kde.windowtitle"
        "org.kde.plasma.mediacontroller"
        "org.kde.plasma.systemtray"
        "org.kde.plasma.digitalclock"
        "org.kde.plasma.showdesktop"
        "org.kde.plasma.cameraindicator"
        "org.kde.plasma.activitypager"
      ];
    }
  ];
}
