{ pkgs
, ...
}: {
  environment.systemPackages = [ pkgs.headsetcontrol ];
  services.udev.packages = [ pkgs.headsetcontrol ];
}
