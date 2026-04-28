{ pkgs, ... }:

{
  # Enable local ai serve
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "11.0.0";
  };

  # Provide access via web ui
  services.nextjs-ollama-llm-ui.enable = true;

  # Make hip available at known-path
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Diagnostic tooling
  environment.systemPackages = with pkgs; [ 
    libdrm
    llmfit
    opencode
    rocmPackages.rocm-smi
  ];
}
