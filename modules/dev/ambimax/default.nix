{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    k9s
  ];
}
