{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = { 
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+file:/etc/nixos/secrets";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr_contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixifiedAi = {
      url = "github:nixified-ai/flake";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, secrets,... }@inputs: {
    nixosConfigurations = {
      "fabians-nix-desktop" = nixpkgs.lib.nixosSystem rec{
        system = "x86_64-linux";
        specialArgs = {
          user="fabian"; 
          hyprpkgs = inputs.hypr_contrib.packages.${system};
          wallpaper = hosts/desktop/wallpaper.png;
          inherit inputs; 
        };
        modules = [
          inputs.nixifiedAi.nixosModules.invokeai-amd
          {  
            nix.settings = {
              trusted-users = ["fabian"];
              substituters = ["https://hyprland.cachix.org"];
              trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
            };
          }

          ./hosts/desktop/default.nix

          # home-manager
          home-manager.nixosModules.home-manager
          ./hosts/desktop/home.nix

          # others
          secrets.nixosModules.desktop
        ];
      };
    };

    darwinConfigurations."MacBook-Pro-FK" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        user="fabian";
        inherit inputs;
      };
      modules = [
        home-manager.darwinModules.home-manager 
        ./hosts/macbook/default.nix
        ./hosts/macbook/home.nix
        {
          system = {
            stateVersion = 4;
            configurationRevision = self.rev or self.dirtyRev or null;
          };
          nixpkgs.hostPlatform = "x86_64-darwin";
          services.nix-daemon.enable = true;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."MacBook-Pro-FK".pkgs;
  };
}
