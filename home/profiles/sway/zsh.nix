{ pkgs, lib, ... }:

{
  # Sway keeps powerlevel10k, starship is for the stacks noctalia themes
  programs.starship.enable = lib.mkForce false;

  programs.zsh = {
    plugins = [
      {
        name = "powerlevel10k";
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        src = pkgs.zsh-powerlevel10k;
      }
    ];

    initContent = ''
      # Load powerlevel10k config
      source ${./zsh.p10k.sh}
    '';
  };
}
