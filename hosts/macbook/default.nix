{ config, pkgs, inputs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  imports = [
    ../../modules/terminal/zsh
  ];

  users.users."fabian" = {
    home="/Users/fabian";
  };

  environment.systemPackages = with pkgs; [
    ## Cli
    iterm2
    comma
    nano
    zoxide

    ## Tools
    vscode
    
    ## Kube
    k9s
    
    ## JS
    nodejs
    yarn

  ];

  # Apps in here need to be uninstalled manually
  homebrew = {
    enable=true;
    taps = [
      "homebrew/cask-versions"
    ];
    casks=[
      ## Desktop
      "firefox-developer-edition"
      "amethyst"
      "logi-options-plus"
      "spotify"
      "obs"

      "docker"
      "tableplus"
      "another-redis-desktop-manager"

      # Editors
      "jetbrains-toolbox"
      "sublime-text"
      "libreoffice"
      "onlyoffice"
    ];

    masApps={
      "WireGuard"=1451685025;
      "Sequel Ace"=1518036000;
      "Numbers"=409203825;
    };
  };
}
