{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "led-battery-monitor";
  version = "v1.0.3";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "ctsdownloads";
    repo = pname;
    rev = version;
    hash = "sha256-5bahW1uaCt/2gna3ZWN62uBzfjTi4SuklYIeEcM0dSg=";
  };

  build-system = with python3Packages; [
    pyinstaller
    pyserial
    psutil
  ];

  buildPhase = ''
    python -m PyInstaller --onefile --console --name ${pname} leds.py
  '';

  installPhase = ''
    mkdir $out
    cp -r dist $out/bin
  '';
}
