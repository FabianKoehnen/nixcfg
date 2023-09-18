{ pkgs, hyprland, inputs, user, ... }:

{ 
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };
  home-manager.users.${user} = {
    config = {
      xdg.enable = true;
      home = {
        stateVersion = "23.11";
        packages = with pkgs; [
          piper
          
          teamspeak5_client
          signal-desktop
          discord
        ];
      };

      programs = {
        eza.enable = true;
      };

    };
  };
}