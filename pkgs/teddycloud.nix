{ stdenv
, lib
, fetchFromGitHub
, buildNpmPackage
, git
, libfaketime
, openssl
, protobufc
, which
}:

let
  version = "0.6.4";
  
  src = fetchFromGitHub {
    owner = "toniebox-reverse-engineering";
    repo = "teddycloud";
    rev = "tc_v${version}";
    hash = "sha256-KSqD91b9f9cuPxn8vWY9oy/GH6zDk/VXfCI/kOboYI4=";
    fetchSubmodules = true;
  };

  rebuildWeb = false;

  web = buildNpmPackage {
    pname = "teddycloud-web";
    inherit version src;
    sourceRoot = "source/teddycloud_web";
    npmDepsHash = "sha256-HLxNRekbNn/NizWtnp8DnmJYuALLxnz2a28cQ6TILiQ=";
  };

in stdenv.mkDerivation {
    pname = "teddycloud";
    inherit version src;

    dontConfigure = true;

    nativeBuildInputs = [
      git
      libfaketime 
      openssl
      protobufc
      which
    ];

    makeFlags = [ "build" ];

    # Fix failure on build warnings 
    NO_WARN_FAIL = 1;

    # Fix broken version detection
    CFLAGS = "-DBUILD_VERSION=\\\"v${version}\\\"";

    installPhase = ''
      mkdir -p $out/share
      cp -r bin $out
      cp -r contrib/data/www $out/share
    '' + lib.optionalString rebuildWeb ''
      rm -rf $out/share/www/web
      ln -s ${web}/lib/node_modules/teddycloud-web $out/share/www/web
    '';

    passthru = { inherit web; };
  }
