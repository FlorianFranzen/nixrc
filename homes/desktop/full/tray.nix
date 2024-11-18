{
  systemd.user.targets.tray.Unit = {
    Description = "Dummy tray target.";
    Requires = [ "graphical-session-pre.target" ];
  };
}
