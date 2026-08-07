{ lib
, user
, ...
}:
{
  imports = [
    ../default.nix
  ];

  # Power management defaults
  powerManagement = {
    enable = lib.mkDefault true;
  };
}
