{ lib
, pkgs
, ...
}:
{
  imports = [
    ../../modules/terminal/zsh
    ../../modules/base/git
    ../../modules/terminal/kitty
  ];

  environment.systemPackages = with pkgs; [
    util-linux
    wget
    killall
    eza
    tio
    parted
    unzip
    zip
    docker-compose
    sops
    symfony-cli
  ];
}
