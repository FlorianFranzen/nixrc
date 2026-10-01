{ config, pkgs, lib, ... }:

let
  cfg = config.services.odysseus;
in {
  options.services.odysseus = {
    enable = lib.mkEnableOption "Odysseus self-hosted AI workspace";

    package = lib.mkPackageOption pkgs "odysseus" { };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/odysseus";
      description = "Directory holding all persistent data of Odysseus and its vector database.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Address the Odysseus web interface listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7000;
      description = "Port the Odysseus web interface listens on.";
    };

    chromaPort = lib.mkOption {
      type = lib.types.port;
      default = 8100;
      description = "Loopback port of the bundled ChromaDB server used for RAG and semantic memory.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        LLM_HOST = "llm.example.org";
        SEARXNG_INSTANCE = "http://127.0.0.1:8888";
      };
      description = ''
        Extra environment variables for Odysseus. See `.env.example` in the
        source tree for all supported settings.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/odysseus.env";
      description = ''
        Environment file with secrets such as API keys or
        `ODYSSEUS_ADMIN_PASSWORD`, kept out of the world-readable Nix store.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the web interface port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.odysseus-chroma = {
      description = "ChromaDB vector database for Odysseus";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        ANONYMIZED_TELEMETRY = "False";
        HOME = cfg.stateDir;
      };

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/odysseus-chroma run \
            --path ${cfg.stateDir}/chroma \
            --host 127.0.0.1 \
            --port ${toString cfg.chromaPort}
        '';
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "odysseus";
        DynamicUser = true;
        Restart = "on-failure";
        PrivateTmp = true;
        ProtectHome = true;
      };
    };

    systemd.services.odysseus = {
      description = "Odysseus self-hosted AI workspace";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "odysseus-chroma.service" ];
      wants = [ "odysseus-chroma.service" ];

      # Tools probed at runtime: tmux for background jobs, npx for the browser MCP server
      path = with pkgs; [ bash tmux nodejs git openssh curl ];

      environment = {
        ODYSSEUS_DATA_DIR = "${cfg.stateDir}/data";
        HOME = cfg.stateDir;
        HF_HOME = "${cfg.stateDir}/hf_home";
        CHROMADB_HOST = "127.0.0.1";
        CHROMADB_PORT = toString cfg.chromaPort;
        ANONYMIZED_TELEMETRY = "False";
        PYTHONUNBUFFERED = "1";
        # tmux needs a usable shell, the dynamic user has none
        SHELL = lib.getExe pkgs.bashInteractive;
      } // cfg.environment;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --host ${cfg.host} --port ${toString cfg.port}";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "odysseus";
        DynamicUser = true;
        Restart = "on-failure";

        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        # onnxruntime needs an executable stack and full /proc
        MemoryDenyWriteExecute = false;
        ProcSubset = "all";
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ florianfranzen ];
}
