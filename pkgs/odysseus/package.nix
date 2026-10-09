{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, python3
, unstableGitUpdater
, extraPackages ? (ps: [ ])
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    bcrypt
    beautifulsoup4
    caldav
    charset-normalizer
    chromadb
    croniter
    cryptography
    fastapi
    fastembed
    httpcore
    httpx
    icalendar
    markdown
    mcp
    nh3
    numpy
    pillow
    pydantic
    pydantic-settings
    pyotp
    pypdf
    python-dateutil
    python-dotenv
    python-magic
    python-multipart
    qrcode
    sqlalchemy
    uvicorn
    youtube-transcript-api
  ] ++ extraPackages ps);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "odysseus";
  version = "1.0.3-unstable-2026-09-05";

  src = fetchFromGitHub {
    owner = "odysseus-dev";
    repo = "odysseus";
    rev = "934d23c0be29c9721385f34565c0ae2cbd60da04";
    hash = "sha256-/kGtXHIP9XTMqxK7aP5BotnCKY1Zc9MVUFVd5w0HdMg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # Lets patchShebangs resolve the scripts' python3 to this env
  buildInputs = [ pythonEnv ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/odysseus $out/bin
    cp -r . $out/share/odysseus
    rm -rf $out/share/odysseus/{tests,website,swift,docker,.github}

    makeWrapper ${pythonEnv}/bin/uvicorn $out/bin/odysseus \
      --prefix PYTHONPATH : $out/share/odysseus \
      --add-flags "app:app"

    ln -s $out/share/odysseus/scripts/odysseus $out/bin/odysseus-cli
    ln -s ${pythonEnv}/bin/chroma $out/bin/odysseus-chroma

    runHook postInstall
  '';

  passthru = {
    inherit pythonEnv;
    updateScript = unstableGitUpdater { branch = "main"; };
  };

  meta = {
    description = "Self-hosted AI workspace";
    homepage = "https://github.com/odysseus-dev/odysseus";
    license = lib.licenses.agpl3Only;
    mainProgram = "odysseus";
    maintainers = with lib.maintainers; [ florianfranzen ];
    platforms = lib.platforms.linux;
  };
})
