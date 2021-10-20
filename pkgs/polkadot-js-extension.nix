{ buildFirefoxXpiAddon, lib }:

buildFirefoxXpiAddon {
  pname = "polkadot-js";
  version = "0.40.2";
  addonId = "{7e3ce1f0-15fb-4fb1-99c6-25774749ec6d}";
  url = "https://addons.mozilla.org/firefox/downloads/file/3840870/polkadotjs_extension-0.40.2-fx.xpi";
  sha256 = "fh/mq2hHgGAwZRaJExMkTfSDzMVTMl07IrtT2vfzytA=";
  meta = with lib; {
    homepage = "https://github.com/polkadot-js/extension";
    description = "Manage your Polkadot accounts outside of dapps. Injects the accounts and allows signs transactions for a specific account.";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
