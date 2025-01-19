{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    orca-slicer
  ];

  networking.firewall.allowedUDPPorts = [ 2021 ];
}
