{ pkgs, user, ... }:

{
  home-manager.users.${user}.programs = {
    wezterm = {
      enable = true;
    };
  };
}