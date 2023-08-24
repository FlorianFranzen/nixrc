{ modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";
}

