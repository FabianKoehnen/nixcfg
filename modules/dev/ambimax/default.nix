{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pkgs.bc
  ];
}
