{ pkgs, ...}:

{
  home.packages = [ pkgs.mercurial ];

  programs.mercurial = rec {
    enable = true;
    userName = "Florian Franzen";
    userEmail = "Florian@Franzen.io";
    extraConfig = {
      email = {
        from = "${userName} <${userEmail}>";
        charset = "utf-8";
      };

      extensions.patchbomb = "";

      diff.git = 1;

      smtp = {
        host = "smtp.denkmuskel.org";
        port = 587;
        tls = "starttls";
        username = "florian";
      };
    };
  };
}
