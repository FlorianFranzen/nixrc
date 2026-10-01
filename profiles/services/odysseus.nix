{ pkgs, ... }:

let
  searxPort = 8888;
in {
  services.odysseus = {
    enable = true;

    # Optional features: PDF form filling and DuckDuckGo search without API key
    package = pkgs.odysseus.override {
      extraPackages = ps: with ps; [
        pymupdf
        ddgs
        # Local speech-to-text and office document extraction both pull in
        # torch, which currently fails to build with rocm support
        #faster-whisper
        #markitdown
      ];
    };

    environment.SEARXNG_INSTANCE = "http://127.0.0.1:${toString searxPort}";
  };

  # Tools probed at runtime: youtube comments, agent file search,
  # browser automation via the playwright MCP server and GGUF serving
  systemd.services.odysseus.path = with pkgs; [
    yt-dlp
    ripgrep
    chromium
    llama-cpp
  ];

  # Local metasearch backend for web search and deep research
  services.searx = {
    enable = true;
    environmentFile = "/var/lib/searx/secret.env";
    settings = {
      server = {
        port = searxPort;
        bind_address = "127.0.0.1";
        secret_key = "$SEARXNG_SECRET";
      };
      search.formats = [ "html" "json" ];
    };
  };

  # Generate the secret key once, read by systemd as root
  systemd.services.searx-secret = {
    description = "Generate SearXNG secret key";
    requiredBy = [ "searx-init.service" ];
    before = [ "searx-init.service" ];
    unitConfig.ConditionPathExists = "!/var/lib/searx/secret.env";

    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "searx";
      UMask = "0077";
    };

    script = ''
      echo "SEARXNG_SECRET=$(${pkgs.openssl}/bin/openssl rand -hex 32)" > /var/lib/searx/secret.env
    '';
  };
}
