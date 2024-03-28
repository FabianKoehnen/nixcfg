{ config, lib, pkgs, user, ... }:
{
  home-manager.users.${user} = {
    programs.git = {
      enable = true;
      userName  = "fabianKoehnen";
      userEmail = "42027473+FabianKoehnen@users.noreply.github.com";
    };
  };
}