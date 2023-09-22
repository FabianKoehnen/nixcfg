{ pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
    # superTuxKart
  ];

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
    # package = pkgs.steam.override {
    #   extraPkgs = pkgs: with pkgs; [
    #     gamescope
    #     mangohud
    #   ];
    # };
  };

  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  # programs.gamemode = {
  #   enable = true;
  # };

  # home-manager.users.${user} = {
  #   programs.mangohud = {
  #     enable = true;
  #   };
  # };
}