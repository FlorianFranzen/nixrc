{ buildFirefoxXpiAddon, lib }:

buildFirefoxXpiAddon {
  pname = "tab-stash";
  version = "2.11.1";
  addonId = "tab-stash@condordes.net";
  url = "https://addons.mozilla.org/firefox/downloads/file/4013515/tab_stash-2.11.1.xpi";
  sha256 = "7D+TEZ064VwzBv3gzeYYLfprynCu/Q6HDxNmEOZEKAo=";
  meta = with lib; {
    homepage = "https://josh-berry.github.io/tab-stash";
    description = "Tab Stash is a no-fuss way to save and organize batches of tabs as bookmarks.";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
