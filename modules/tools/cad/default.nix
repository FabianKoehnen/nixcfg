{ pkgs, ... }: {
  imports = [
    ./openscad.nix
    # ./flatcam.nix
  ];
  environment.systemPackages = with pkgs; [
    freecad-wayland
  ];
}
