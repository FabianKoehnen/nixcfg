{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr_contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "fabians-nix-desktop" = nixpkgs.lib.nixosSystem rec{
        system = "x86_64-linux";
        specialArgs = {
          user="fabian"; 
          hyprpkgs = inputs.hypr_contrib.packages.${system};
          inherit inputs; 
        };
        modules = [
          {  
            nix.settings = {
              substituters = ["https://hyprland.cachix.org"];
              trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
            };
          }

          ./hosts/desktop/default.nix
          


          home-manager.nixosModules.home-manager
          
          ./hosts/desktop/home.nix       
        ];
      };
    };

#    homeConfigurations."fabian@fabians-nix-desktop" = home-manager.lib.homeManagerConfiguration {
#      pkgs = nixpkgs.legacyPackages.x86_64-linux;

#      modules = [
 #       inputs.
#        {wayland.windowManager.hyprland.enable = true;}
#      ];
#    };

  };
}
