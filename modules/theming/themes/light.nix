{ pkgs, ... }: {
  stylix.image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish.png";
    sha256 = "EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/humanoid-light.yaml";
}
