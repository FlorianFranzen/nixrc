# Games, emulators and gaming tools, installed as an ftl layer so they can lag
# behind the base system when a bump breaks one of them. System-level support
# (steam, gamescope, 32-bit audio/graphics) stays in profiles/gaming.nix.
{
  kind = "apps";

  packages =
    pkgs: with pkgs; [
      cemu
      clonehero
      discord
      dolphin-emu
      easyeffects
      goverlay
      joycond
      lutris
      mangohud
      mindustry
      eden
      ryubing
      supertuxkart
      #warzone2100
      samba
      wineWow64Packages.waylandFull
      winetricks
    ];
}
