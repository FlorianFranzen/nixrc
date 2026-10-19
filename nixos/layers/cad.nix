# Useful packages for "hardware" development, installed as an ftl layer.
{
  kind = "packages";

  packages =
    pkgs: with pkgs; [
      openscad-unstable
      librecad
      freecad
      kicad
    ];
}
