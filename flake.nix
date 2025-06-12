{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "github:nix-community/nixvim/nixos-25.05";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-module-sentinalone = {
      url = "git+ssh://git@github.com/ambimax/nixos-module-sentinalone?ref=main";
      # ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , secrets
    , systems
    , nixpkgs-unstable
    , ...
    } @ inputs:
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
            unstable = nixpkgs-unstable.legacyPackages.${system};
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

            # home-manager
            home-manager.nixosModules.home-manager
            ./hosts/desktop/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }

            # others
            secrets.nixosModules.desktop
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        "fabians-nix-laptop" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            unstable = nixpkgs-unstable.legacyPackages.${system};
            user = "fabian";
            wallpaper = {
              light = hosts/desktop/wallpaper.png;
              dark = hosts/desktop/wallpaper.png;
            };
            hyprland-extra-config = ''
              monitor = DP-1, 1920x1080, 0x0, 1,vrr,1
            '';
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/default.nix

            # home-manager
            home-manager.nixosModules.home-manager
            ./hosts/laptop/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
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
        "tuxSiriusGen2-fk" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            user = "fabian";
            unstable = nixpkgs-unstable.legacyPackages.${system};
            hyprpkgs = inputs.hypr_contrib.packages.${system};
            wallpaper = {
              light = hosts/work/tuxSiriusGen2/wallpaper/light.png;
              dark = hosts/work/tuxSiriusGen2/wallpaper/dark.png;
            };
            hyprland-extra-config = ''
              bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-2, disable"
              bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-2, 2560x1440@165.0,1920x1440,1.0"
            '';
            inherit inputs;
          };
          modules = [
            inputs.impermanence.nixosModules.impermanence
            inputs.nix-flatpak.nixosModules.nix-flatpak

            inputs.nixos-module-sentinalone.nixosModules.default
            {
              environment.systemPackages = [
                inputs.nixos-module-sentinalone.packages.${system}.default
              ];
              services.sentinelone = {
                enable = true;
                package = inputs.nixos-module-sentinalone.packages.${system}.default;
                sentinelOneManagementTokenPath = "/persist/sentinelOneSiteToken";
                email = "fabian.koehnen@open.de";
                serialNumber = "EMNM16HP958G344T0337";
              };
            }

            ./hosts/work/tuxSiriusGen2/default.nix

            # home-manager
            home-manager.nixosModules.home-manager
            ./hosts/work/tuxSiriusGen2/home.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
            }

            # others
            secrets.nixosModules.tuxSiriusGen2
            inputs.sops-nix.nixosModules.sops
          ];
        };

      };

      darwinConfigurations."MacBook-Pro-FK" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          unstable = nixpkgs-unstable.legacyPackages.x86_64-darwin;
          user = "fabian";
          inherit inputs;
        };
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/macbook/default.nix
          ./hosts/macbook/home.nix
          {
            nix.linux-builder = {
              enable = true;
              #                ephemeral = true;
              #                trusted-users = [ "builder" "fabian" ];
              #                package = inputs.nixpkgs-unstable.legacyPackages.x86_64-darwin.darwin.linux-builder;
              #                config = {
              #                  nix = {
              #                    settings = {
              #                      trusted-users = [ "builder" "fabian" ];
              #                    };
              ##                    gc.automatic = true;
              #                  };

              #                  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
              #                };
            };
            nix.buildMachines = [
              {
                hostName = "linux-builder";
                mandatoryFeatures = [ ];
                maxJobs = 1;
                protocol = "ssh";
                publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
                speedFactor = 1;
                sshKey = "/etc/nix/builder_ed25519";
                sshUser = "builder";
                supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
                system = "x86_64-linux";
              }
            ];
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
