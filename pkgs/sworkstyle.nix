{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "sworkstyle";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    sha256 = "y8JLPqBkE9GSSPnrMK1AYkQSJgdjPh6TVhWYR0KHPXU=";
  };

  cargoSha256 = "vz+n3XVQxIqVSpPr2Lrzotqe11HCJ/qMMRJUJhC8260=";

  #doCheck = false; # No tests

  meta = with lib; {
    description = "Map workspace name to icons defined depending on contained windows.";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
