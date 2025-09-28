# (c) under Apache 2.0 License, from github:Trundle/NixOS-WSL
{ stdenv, lib, replaceVarsWith, daemonize }:

{ wrapperDir, fsPackages, defaultUser }:

replaceVarsWith {
  name = "syschdemd";
  src = ./syschdemd.sh;
  dir = "bin";
  isExecutable = true;

  buildInputs = [ daemonize ];

  replacements = {
    inherit (stdenv) shell;
    inherit daemonize defaultUser wrapperDir;

    fsPackagesPath = lib.makeBinPath fsPackages;
  };
}
