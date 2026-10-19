{ pkgs, ... }:

{
  # The account itself (uid, wheel, SSH keys) and the home per host come from
  # users/florian through ftl; this is what it does not know.
  users.users.florian = {
    description = "Florian Franzen";
    shell = pkgs.zsh;
  };
}
