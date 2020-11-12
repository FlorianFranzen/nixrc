{ pkgs }:

with pkgs.lib;

let

  mkHost = name: nixosSystem (import (./. + "/${name}"));

  hosts = [
    # Personal Laptop
    "chomsky"

    # Personal Netbook
    "hull"

    # Personal NAS
    "tesla"

    # Personal Cloud
    #"turing"
  ];

in genAttrs hosts mkHost
