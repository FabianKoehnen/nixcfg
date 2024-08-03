{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "github:fabianKoehnen/nixcfg-secrets";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hypr_contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";

    #   # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
    #   inputs.hyprland.follows = "hyprland";
    # };

    nixifiedAi = {
      url = "github:nixified-ai/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    stylix.url = "github:danth/stylix/release-23.11";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
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
            wallpaper = hosts/desktop/wallpaper.png;
            hyprland-extra-config = ''
              monitor = DP-1, 1920x1080, 2560x0, 1,vrr,1
              monitor = DP-2, 2560x1440@165,0x0, 1,vrr,1
            '';
            inherit inputs;
          };
          modules = [
            #stylix.nixosModules.stylix
            #{
            #  stylix.image = nixpkgs.lib.mkDefault hosts/desktop/wallpaper.png;
            #  stylix.autoEnable=false;
            #  home-manager.users.fabian.stylix.targets.firefox.profileNames = ["default-release"];
            #}

            # inputs.microvm.nixosModules.host

            inputs.nixifiedAi.nixosModules.invokeai-amd
            {
              nix.settings = {
                trusted-users = [ "fabian" ];
                substituters = [ "https://hyprland.cachix.org" ];
                trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
              };
            }

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
              ];
            }

            # others
            secrets.nixosModules.desktop
            inputs.sops-nix.nixosModules.sops
          ];
        };

        "fabians-nix-laptop" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            user = "fabian";
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

            secrets.nixosModules.laptop
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
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
            wallpaper = hosts/work/tuxSiriusGen2/wallpaper.png;
            hyprland-extra-config = ''
              bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-2, disable"
              bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-2, 2560x1440@165.0,1920x1440,1.0"
            '';
            inherit inputs;
          };
          modules = [
            inputs.impermanence.nixosModules.impermanence
            {
              nix.settings = {
                trusted-users = [ "fabian" ];
                substituters = [ "https://hyprland.cachix.org" ];
                trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
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

      checks = eachSystem (pkgs: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      devShell = eachSystem (
        pkgs:
        nixpkgs.legacyPackages.${pkgs.system}.mkShell {
          inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
        }
      );
    };
}
