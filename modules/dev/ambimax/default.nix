{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    k9s
    ddev
    mkcert
    nss
  ];

  virtualisation.docker = {
    enable = true;
  };
}
