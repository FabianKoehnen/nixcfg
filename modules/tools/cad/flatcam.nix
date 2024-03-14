{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    flatcam
  ];
}
