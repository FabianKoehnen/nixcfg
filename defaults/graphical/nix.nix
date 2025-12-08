{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Nix store optimizations and GC
  nix = {
    settings = {
      auto-optimise-store = lib.mkDefault true;
      experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  environment.systemPackages = [
    pkgs.comma
  ];
}
