{ config
, pkgs
, unstable
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "@admin"
        "fabian"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  imports = [
    ../../modules/terminal/zsh
    ../../modules/editors/vscodium
  ];

  users.users."fabian" = {
    home = "/Users/fabian";
  };

  system.defaults = {
    #".GlobalPreferences"."com.apple.mouse.scaling" = (-1.0);
    finder.AppleShowAllFiles = true;
    NSGlobalDomain.AppleShowAllFiles = true;
  };

  environment.systemPackages = with pkgs; [
    ## Cli
    iterm2
    comma
    nano
    zoxide
    kubectx
    direnv

    ## Tools
    vscode

    ## Kube
    k9s

    ## JS
    nodejs
    yarn

    unstable.youtube-music
  ];

  # Apps in here need to be uninstalled manually
  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask-versions"
    ];
    casks = [
      ## Desktop
      "firefox-developer-edition"
      "amethyst"
      "logi-options-plus"
      "obs"
      "yubico-yubikey-manager"
      "yubico-authenticator"

      "docker"
      "tableplus"

      # Editors
      "jetbrains-toolbox"
      "sublime-text"
      "libreoffice"
      "onlyoffice"
    ];

    masApps = {
      "WireGuard" = 1451685025;
      "Sequel Ace" = 1518036000;
      "Numbers" = 409203825;
      "Whatsapp" = 310633997;
      "Battery Monitor" = 836505650;
    };
  };
}
