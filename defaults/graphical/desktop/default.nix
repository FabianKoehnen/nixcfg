{ lib
, ...
}: {
  imports = [
    ../default.nix
  ];

  # Power management defaults
  powerManagement = {
    enable = lib.mkDefault true;
    cpuFreqGovernor = lib.mkDefault "performance";
  };
}
