{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    k9s
    ddev
    mkcert
    nss
    # awscli2
  ];

  virtualisation.docker = {
    enable = true;
  };
}
