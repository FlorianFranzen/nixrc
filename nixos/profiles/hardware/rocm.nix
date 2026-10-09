{ pkgs, ... }:

{
  # Install additional tooling
  environment.systemPackages = with pkgs; [
    btop-rocm
    nvtopPackages.amd
    rocmPackages.rocm-smi
  ];

  # Enable ROCM support in nixpkgs
  nixpkgs.config.rocmSupport = true;

  # Make hip available at known-path
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}

