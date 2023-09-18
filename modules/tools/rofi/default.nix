{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi-wayland
  ];
  
  home-manager.users.${user}.programs = {
    rofi = {
      package = pkgs.rofi-wayland;
    };
  };
}