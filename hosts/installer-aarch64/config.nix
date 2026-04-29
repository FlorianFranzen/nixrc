{ modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "aarch64-linux";
}
