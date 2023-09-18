{ pkgs, user, ... }:

{
  imports = [
    ../starship
  ];

  programs.zsh.enable = true;
  
  home-manager.users.${user}.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
  };
}