{ config, pkgs, user, ... }: {

  # https://nixos.wiki/wiki/Jetbrains_Tools
  environment.systemPackages = with pkgs; [
    pkgs.jetbrains-toolbox
  ];


  environment.localBinInPath = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

    # Jetbrains IDEs
    fontconfig
    stdenv.cc.cc
    openssl
    libxcrypt
    lttng-ust_2_12
    musl
    expat
    libxml2
    xz
  ];
}
