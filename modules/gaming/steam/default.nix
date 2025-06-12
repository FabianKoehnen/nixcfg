{ pkgs, unstable, ... }: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [ vulkan-tools unstable.gamescope gamemode mangohud protontricks ];
  # programs.gamescope = {
  #   enable = true;
  #   package = unstable.gamescope;
  #   capSysNice = false;
  #   args = [
  #     "--rt"
  #     "--backend sdl"
  #   ];
  # };

  # programs.gamemode = {
  #   enable = true;
  # };

  # environment.systemPackages = with pkgs; [
  #   mangohud
  #   protontricks
  # ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
        ];
    };
  };

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };
}
