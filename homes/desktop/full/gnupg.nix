{ pkgs, ... }:

{
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
}
