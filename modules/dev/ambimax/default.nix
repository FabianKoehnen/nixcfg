{ pkgs, unstable, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    k9s
    unstable.ddev
    mkcert
    nss
    # awscli2
  ];

  virtualisation.docker = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 9003 ];
}
