# (c) under Apache 2.0 License, from github:Trundle/NixOS-WSL
{ lib, substituteAll, daemonize }:  

{ wrapperDir, fsPackages, defaultUser }:

substituteAll {
  name = "syschdemd";
  src = ./syschdemd.sh;
  dir = "bin";
  isExecutable = true;

  buildInputs = [ daemonize ];

  inherit daemonize defaultUser wrapperDir;

  fsPackagesPath = lib.makeBinPath fsPackages;
}
