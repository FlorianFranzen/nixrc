{ pkgs, static, ...}:

{
  # Theme pywal and integrations
  pywal.theme = "base16-spacemacs";
  pywal.background = static.wallpapers.nixish-dark;

  # Set cursor theme
  wayland.windowManager.sway.config.seat."*" = {
    xcursor_theme = "Numix-Cursor";
  };

  # Theme status bars
  programs.i3status-rust.bars.top.theme = "modern";
  programs.i3status-rust.bars.bottom.theme = "modern";

  # Set gtk look and feel
  gtk = {

    # materia-theme was removed from nixpkgs (depended on the unmaintained
    # gtk-engine-murrine); falls back to the default theme until a
    # maintained replacement is picked.
    # theme = {
    #   name = "Materia-dark-compact";
    #   package = pkgs.materia-theme;
    # };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
    };
  };
}
