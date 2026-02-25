{ stdenv
, fetchFromGitHub
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let
  modName = "atlantic";
  modPath = "extra";
in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "Aquantia";
    repo = "Aqtion";
    rev = "340d608726cbfa04b6046d74a362e788e1e17d45";
    hash = "sha256-rGaBDjgg+Q2xHoHnFneMMVEqNW2vomN2Gogr63WKB5I=";
  };

  # Compatibility fixes for kernels newer than the driver's last release (2.5.5):
  #   5.15+ ndo_do_ioctl → ndo_eth_ioctl (fixes SIOCSHWTSTAMP)
  #   6.1+  netif_napi_add() 4-arg→3-arg; u64_stats_fetch_*_irq renamed;
  #         macsec_context.prepare removed
  #   6.3+  genl_family.pre_doit: genl_ops → genl_split_ops
  #   6.8+  strlcpy removed; get/set_rxfh use ethtool_rxfh_param struct
  #   6.9+  PCI_IRQ_LEGACY renamed; ethtool_eee→ethtool_keee (bitmap fields)
  #   6.10+ ethtool_ts_info → kernel_ethtool_ts_info
  #   6.11+ bin_attribute.mmap callback gains const qualifier
  #   6.15+ from_timer→timer_container_of; del_timer_sync→timer_delete_sync
  patches = [ ./atlantic.compat.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
  '';
}
