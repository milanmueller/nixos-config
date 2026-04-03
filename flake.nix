{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets.url = "git+ssh://git@github.com/milanmueller/nixos-secrets.git";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crowdsec = {
      url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-themes-base16 = {
      url = "github:milanmueller/cosmic-themes-base16";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-colors,
      sops-nix,
      secrets,
      crowdsec,
      cosmic-themes-base16,
      claude-code,
      nur,
      ...
    }:
    let
      userConfig = {
        username = "milan";
        homeDir = "/home/milan";
      };
      # Host metadata
      hosts = {
        red-miso = {
          inherit userConfig;
          system = "x86_64-linux";
          extraModules = [
            # Apply cosmic-themes-base16 overlay
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    cosmic-themes-base16 = cosmic-themes-base16.packages.${prev.stdenv.hostPlatform.system}.default;
                    claude-code = claude-code.packages.${prev.stdenv.hostPlatform.system}.default;
                  })
                ];
              }
            )
          ];
          extraInputs = {
            inherit nix-colors;
          };
          hmModules = [
            cosmic-themes-base16.homeManagerModules.default
          ];
          hmExtraSpecialArgs = {
            colorParams = import ./hosts/red-miso/color-parameters.nix;
          };
        };
        monomyth = {
          inherit userConfig;
          system = "aarch64-linux";
          extraModules = [ ];
          extraInputs = { inherit nix-colors; };
          hmModules = [ ];
          hmExtraSpecialArgs = { };
        };
        cafo = {
          inherit userConfig;
          system = "aarch64-linux";
          extraModules = [
            # crowdsec.nixosModules.crowdsec
          ];
          extraInputs = {
            inherit nix-colors;
            webParams = import hosts/cafo/web/parameters.nix;
          };
          hmModules = [ ];
          hmExtraSpecialArgs = { };
        };
      };
      mkHost =
        name:
        {
          system,
          extraModules,
          extraInputs,
          userConfig,
          hmModules,
          hmExtraSpecialArgs,
        }:
        # "Template for host config"
        nixpkgs.lib.nixosSystem {
          modules = [
            # common modules
            hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            secrets.nixosModules.default
            { nixpkgs.hostPlatform = system; }
            {
              networking.hostName = "${name}";
              # Add NUR overlay
              nixpkgs.overlays = [
                nur.overlays.default
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.users.${userConfig.username}.imports = [
                hosts/${name}/home.nix
                nix-colors.homeManagerModules.default
              ]
              ++ hmModules;
              home-manager.extraSpecialArgs = {
                inherit nix-colors userConfig;
              }
              // hmExtraSpecialArgs;
            }
          ]
          ++ extraModules;
          specialArgs = {
            inherit userConfig;
          }
          // extraInputs;
        };
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              config.allowUnfree = true;
              localSystem = system;
            };
          }
        );
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            # packages = with pkgs; [
            # ];
            shellHook = ''
              # Welcome message
              echo "Welcome to the NixOS config environment"
            '';
          };
        }
      );
    };
}
