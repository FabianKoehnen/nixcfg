{ pkgs, user, ... }:

{
  programs.starship.enable = true;
  
  home-manager.users.${user}.programs.starship = {
    enable = true;
  };
}