{ pkgs, user, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs;
    [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
    extraPackages32 = with pkgs.pkgsi686Linux;
    [
      driversi686Linux.amdvlk
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.gamescope = {
    enable = true;
  };
}