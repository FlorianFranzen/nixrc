# Deployment of the base system (comin) and of ftl layers.
#
# Hosts follow master of the GitHub repository. The ftl pipeline on pavlov
# fast-forwards master with signed flake.lock bumps once every required host
# builds; layers that failed to build are pinned to their last good commit in
# ftl-layers.json and installed by ftl-layers after each comin deployment.
{ lib, static, ... }:

{
  # comin follows the flake's repo (mkFlake's `repo`) at this branch; layers
  # are built from the same repository
  fleet.comin.branch = "master";

  services.comin = {
    # Disabled until master is signed end-to-end (user and builder keys) and
    # the pipeline is live; enable per host or here afterwards.
    enable = lib.mkDefault false;

    # Only deploy commits signed by the user's or the builder's key
    # (florian.asc: signing subkey 0x9D6358DA6827C1ED of 0x9E496CBDB62766C1).
    # TODO: add the builder's key once its smartcard is provisioned, e.g.
    #   "${static.keys.pavlov-builder}"
    gpgPublicKeyPaths = [ "${static.keys.florian}" ];

    # Servers switch automatically; laptops confirm (see profiles/laptop.nix)
    deployConfirmer.mode = lib.mkDefault "without";
  };
}
