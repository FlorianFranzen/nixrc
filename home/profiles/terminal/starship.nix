{ config, lib, ... }:

let
  theme = config.theme;

  # Colour from the dark palette, for hosts that do not run noctalia
  nixColour = role: theme.palette.dark.${role};
in
{
  # Prompt layout: left dir + git, right status and environment, host coloured
  theme.starship = c: {
    add_newline = false;

    format = "$os$directory$git_branch$git_commit$git_state$git_status$line_break$character";
    right_format = lib.concatStrings [
      "$status$cmd_duration$jobs$direnv$nix_shell"
      "$python$nodejs$golang$rust$kubernetes"
      "$username$hostname"
    ];

    os = {
      disabled = false;
      style = "fg:${c "foregroundDim"}";
      format = "[$symbol]($style) ";
    };

    directory = {
      style = "bold fg:${c "blue"}";
      truncation_length = 4;
      truncate_to_repo = true;
    };

    git_branch.style = "fg:${c "magenta"}";
    git_status.style = "fg:${c "yellow"}";

    character = {
      success_symbol = "[❯](bold fg:${c "accent"})";
      error_symbol = "[❯](bold fg:${c "red"})";
      vimcmd_symbol = "[❮](bold fg:${c "green"})";
    };

    status = {
      disabled = false;
      style = "fg:${c "red"}";
      format = "[$symbol$status]($style) ";
      symbol = "✘ ";
    };

    cmd_duration = {
      min_time = 2000;
      style = "fg:${c "yellow"}";
      format = "[$duration]($style) ";
    };

    jobs.style = "fg:${c "cyan"}";

    direnv = {
      disabled = false;
      style = "fg:${c "cyan"}";
      format = "[$symbol$loaded$allowed]($style) ";
    };

    nix_shell = {
      style = "fg:${c "blue"}";
      format = "[$symbol$state( \\($name\\))]($style) ";
      impure_msg = "";
    };

    # Only in kubernetes projects, not everywhere a kube config exists
    kubernetes = {
      disabled = false;
      style = "fg:${c "magenta"}";
      detect_env_vars = [ "KUBECONFIG" ];
      detect_files = [ "Chart.yaml" "kustomization.yaml" "skaffold.yaml" "Tiltfile" ];
      detect_folders = [ "k8s" "kubernetes" "helm" "charts" "manifests" ];
    };

    # Always show user@host in the host colour, also over ssh
    username = {
      show_always = true;
      style_user = "bold fg:${c "accent"}";
      style_root = "bold fg:${c "red"}";
      format = "[$user]($style)";
    };

    hostname = {
      ssh_only = false;
      style = "bold fg:${c "accent"}";
      format = "[@$hostname]($style)";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = lib.mkIf (theme.enable && theme.managedBy == "nix") (theme.starship nixColour);
  };
}
