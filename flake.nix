{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      # url = "github:fabianKoehnen/nixcfg-secrets";
      url = "git+file:/etc/nixos/secrets";
    };

    hypr_contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixifiedAi = {
    #   url = "github:nixified-ai/flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    impermanence.url = "github:nix-community/impermanence";

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , nix-darwin
    , home-manager
    , home-manager-unstable
    , cosmic-manager
    , secrets
    , systems
    , ...
    }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations = {
        "fabians-nix-desktop" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            user = "fabian";
            unstable = nixpkgs.legacyPackages.${system};
            hyprpkgs = inputs.hypr_contrib.packages.${system};
            wallpaper =
              let
                droolBackground = import ./pkgs/gnome-backgrounds-png { pkgs = nixpkgs.legacyPackages.${system}; };
              in
              {
                light = "${droolBackground}/drool-l.png";
                dark = "${droolBackground}/drool-d.png";
              };
            hyprland-extra-config = ''
              monitor = DP-1, 1920x1080, 2560x0, 1,vrr,1
              monitor = DP-2, 2560x1440@165,0x0, 1,vrr,1
            '';
            inherit inputs;
          };
          modules = [
            # inputs.microvm.nixosModules.host

            ./hosts/desktop/default.nix

            # Secure Boot
            inputs.lanzaboote.nixosModules.lanzaboote
            ./modules/base/secureboot.nix

            # home-manager
            home-manager.nixosModules.home-manager
            ./hosts/desktop/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                wallpaper = specialArgs.wallpaper;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                # inputs.nixvim.homeManagerModules.nixvim
                inputs.catppuccin.homeModules.catppuccin
              ];
            }

            # others
            secrets.nixosModules.desktop
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        "fabians-nix-laptop" = nixpkgs-unstable.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            unstable = nixpkgs-unstable.legacyPackages.${system};
            user = "fabian";
            wallpaper =
              let
                droolBackground = import ./pkgs/gnome-backgrounds-png { pkgs = nixpkgs.legacyPackages.${system}; };
              in
              {
                light = "${droolBackground}/drool-l.png";
                dark = "${droolBackground}/drool-d.png";
              };
            hyprland-extra-config = ''
              monitor = DP-1, 1920x1080, 0x0, 1,vrr,1
            '';
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/default.nix

            # home-manager
            home-manager-unstable.nixosModules.home-manager
            ./hosts/laptop/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.catppuccin.homeModules.catppuccin
              ];
            }

            secrets.nixosModules.desktop
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        ##########
        ## Work ##
        ##########
        "blumenpeter-fabian-koehnen" = nixpkgs-unstable.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            unstable = nixpkgs-unstable.legacyPackages.${system};
            user = "fabian";
            wallpaper = let
                droolBackground = import ./pkgs/gnome-backgrounds-png { pkgs = nixpkgs-unstable.legacyPackages.${system}; };
              in
              {
                light = "${droolBackground}/drool-l.png";
                dark = "${droolBackground}/drool-d.png";
              };
            inherit inputs;
          };
          modules = [
            inputs.impermanence.nixosModules.impermanence
            inputs.nix-flatpak.nixosModules.nix-flatpak

            ./hosts/work/blumenPeter/default.nix

            # home-manager
            home-manager-unstable.nixosModules.home-manager
            ./hosts/work/blumenPeter/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                            wallpaper = let
                droolBackground = import ./pkgs/gnome-backgrounds-png { pkgs = nixpkgs-unstable.legacyPackages.${system}; };
              in
              {
                light = "${droolBackground}/drool-l.png";
                dark = "${droolBackground}/drool-d.png";
              };
                inherit inputs;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.catppuccin.homeModules.catppuccin
              ];
            }

            # others
#             secrets.nixosModules.blumenPeter
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # checks = eachSystem (pkgs: {
      #   pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
      #     src = ./.;
      #     hooks = {
      #       nixpkgs-fmt.enable = true;
      #     };
      #   };
      #   formatting = treefmtEval.${pkgs.system}.config.build.check self;
      # });

      # devShell = eachSystem (
      #   pkgs:
      #   nixpkgs.legacyPackages.${pkgs.system}.mkShell {
      #     inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
      #   }
      # );
    };
}
