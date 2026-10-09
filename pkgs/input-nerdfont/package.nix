{
  stdenvNoCC,
  input-fonts,
  fontforge,
  nerd-font-patcher,
}:

stdenvNoCC.mkDerivation {
  pname = "input-nerdfont";
  inherit (input-fonts) version;

  src = input-fonts;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype

    cd share/fonts/truetype

    for font in InputMono-*.ttf InputMonoCompressed-*.ttf InputMonoCondensed-*.ttf InputMonoNarrow-*.ttf; do
    	nerd-font-patcher --outputdir $out/share/fonts/truetype $font
    done

    runHook postInstall
  '';

  buildInputs = [
    fontforge
    nerd-font-patcher
  ];
}
