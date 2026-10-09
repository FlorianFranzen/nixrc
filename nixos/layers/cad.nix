# Useful packages for "hardware" development, installed as an ftl layer.
{
  kind = "apps";

  packages =
    pkgs: with pkgs; [
      openscad-unstable
      librecad
      freecad
      kicad
    ];
}
