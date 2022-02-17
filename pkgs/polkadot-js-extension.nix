{ buildFirefoxXpiAddon, lib }:

buildFirefoxXpiAddon {
  pname = "polkadot-js";
  version = "0.42.2";
  addonId = "{7e3cef0-15fb-4fb1-99c6-25774749ec6d}";
  url = "https://addons.mozilla.org/firefox/downloads/file/3879725/polkadotjs_extension-0.42.2-fx.xpi";
  sha256 = "SoGFDrHdgwWfNjjhXP6DV+NLPP7W4Ua4jV3lx0e9RKI=";
  meta = with lib; {
    homepage = "https://github.com/polkadot-js/extension";
    description = "Manage your Polkadot accounts outside of dapps. Injects the accounts and allows signs transactions for a specific account.";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
