{ config, pkgs, ... }:

{
  # Enable local ai serve
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "11.0.0";
  };

  # Provide access via web ui
  services.nextjs-ollama-llm-ui.enable = true;

  # Use local ollama as model backend for the ai workspace
  services.odysseus.environment.OLLAMA_BASE_URL =
    "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
  systemd.services.odysseus = {
    after = [ "ollama.service" ];
    wants = [ "ollama.service" ];
  };

  # Diagnostic tooling
  environment.systemPackages = with pkgs; [ 
    libdrm
    llmfit
    opencode
  ];
}
