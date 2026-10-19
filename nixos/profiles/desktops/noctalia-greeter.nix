{ config, lib, username, ... }:

let
  # Follow the user's theme for the cursor, if the home sets one
  theme = config.home-manager.users.${username}.theme or null;
  cursor = if theme != null && theme.enable then theme.cursorTheme else null;
in
{
  services.displayManager.noctalia-greeter = {
    enable = true;

    # Let the shell push wallpaper, palette and mode without a password prompt
    passwordlessSyncUsers = [ username ];

    cursorTheme = lib.mkIf (cursor != null && cursor.package != null) {
      inherit (cursor) name package;
    };

    settings = {
      session.default = "Umbriel";
      user.default = username;

      appearance.scheme = "Synced";

      keyboard = {
        layout = "eu";
        options = "compose:ralt";
        numlock = true;
      };
    };
  };
}
