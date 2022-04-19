{ buildFirefoxXpiAddon, lib }:

buildFirefoxXpiAddon {
  pname = "tab-stash";
  version = "2.10.3";
  addonId = "tab-stash@condordes.net";
  url = "https://addons.mozilla.org/firefox/downloads/file/3917868/tab_stash-2.10.3-fx.xpi";
  sha256 = "oev4uKAtvxYQ7oPbHeoDorPCMFqtQ0ejtrMrXBbGdt0=";
  meta = with lib; {
    homepage = "https://josh-berry.github.io/tab-stash";
    description = "Tab Stash is a no-fuss way to save and organize batches of tabs as bookmarks.";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
