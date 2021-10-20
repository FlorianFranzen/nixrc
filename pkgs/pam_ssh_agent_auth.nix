{ pam_ssh_agent_auth }:

pam_ssh_agent_auth.overrideAttrs (old: {
  patches = old.patches ++ [
    ./pam_ssh_agent_auth.just-one-big-cookie.patch
  ];
})
