{ pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
    kicad
  ];
}