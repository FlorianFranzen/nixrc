{ lib, pkgs, ... }:

let
  release = "18.1";
  build = "202111291420";

  images = pkgs.fetchzip {
    url = "mirror://sourceforge/blissos-dev/waydroid/lineage/lineage-${release}/Lineage-OS-${release}-waydroid_x86_64-${build}-foss-sd-hd-ex_ax86-vaapi_gles-aep.zip";
    sha256 = "PK9zTibD3OiGVw5Ss954eWmmW40nP3NJ7Nx9AcEu5tQ=";
    stripRoot = false;
  };

  # Use latest binder API
  binderConf = ''
    [Protocol]
    /dev/anbox-binder = aidl3
    /dev/anbox-vndbinder = aidl3
    /dev/anbox-hwbinder = hidl

    [ServiceManager]
    /dev/anbox-binder = aidl3
    /dev/anbox-vndbinder = aidl3
    /dev/anbox-hwbinder = hidl

    [General]
    ApiLevel = 30
  '';
in {
  virtualisation = {
    waydroid.enable = true;
  };

  # FIXME: Provide working Android 11 image
  #environment.etc."waydroid-extra/images".source = images;

  # TODO: Is this still needed?
  environment.etc."gbinder.d/anbox.conf".source = pkgs.writeText "anbox.cfg" binderConf;

  # Override some outdated settings
  systemd.services.waydroid-container.serviceConfig.ExecStart = lib.mkForce "${pkgs.waydroid}/bin/waydroid -w container start";
  environment.etc."gbinder.d/waydroid.conf".source = lib.mkForce (pkgs.writeText "waydroid.cfg" binderConf;
}
