{ pkgs, config, user, ... }: {
  home-manager.users.${user}.services.darkman =
    let
      hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
    in
    {
      enable = true;
      settings = {
        lat = 49.0;
        lng = 7.0;
        usegeoclue = false;
        dbusserver = true;
        portal = true;
      };
      darkModeScripts = { };
      lightModeScripts = { };
    };


  # specialisation = {
  #   light.configuration = import ../themes/light.nix;
  #   dark.configuration = import ../themes/dark.nix;
  # };  

  # specialisation = {
  #   light.configuration = {
  #     stylix.autoEnable=true;
  #     stylix.image = pkgs.fetchurl {
  #       url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish.png";
  #       sha256 = "EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
  #     };

  #     stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/humanoid-light.yaml";
  #   };
  #   dark.configuration = {
  #     stylix.autoEnable=true;
  #     stylix.image = pkgs.fetchurl {
  #       url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-binary-black.png";
  #       sha256 = "mhSh0wz2ntH/kri3PF5ZrFykjjdQLhmlIlDDGFQIYWw=";
  #     };
  #     stylix.polarity = "dark";
  #     stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/humanoid-dark.yaml";
  #   };
  # };
}
