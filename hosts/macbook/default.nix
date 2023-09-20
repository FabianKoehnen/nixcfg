{ config, pkgs, inputs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  users.users."fabian" = {
    home="/Users/fabian";
  };

  environment.systemPackages = with pkgs; [
    ## Cli
    comma
    nano
    starship
    zoxide

    ## Tools
    vscode
    
    ## Kube
    k9s
    
    ## JS
    nodejs
    yarn
   
  ];

  homebrew = {
    enable=true;
    casks=[
      ## Desktop
      "amethyst"
      "logi-options-plus"
      "spotify"

      "docker"
      "tableplus"

      # Editors
      "jetbrains-toolbox"
      "sublime-text"
      "libreoffice"
      "onlyoffice"
    ];

    # Apps in here need to be uninstalled manually
    masApps={
      "WireGuard"=1451685025;
      "Sequel Ace"=1518036000;
      "Numbers"=409203825;
    };
  };
}
