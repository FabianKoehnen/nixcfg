{ pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
    flatcam
  ];
}