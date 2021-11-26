{ lib, pkgs, ... }:

{
  virtualisation.waydroid.enable = true;

  environment.etc."gbinder.d/anbox.conf".source = pkgs.writeText "anbox.cfg" ''
    [Protocol]
    /dev/anbox-binder = aidl2
    /dev/anbox-vndbinder = aidl2
    /dev/anbox-hwbinder = hidl

    [ServiceManager]
    /dev/anbox-binder = aidl2
    /dev/anbox-vndbinder = aidl2
    /dev/anbox-hwbinder = hidl
  '';
}
