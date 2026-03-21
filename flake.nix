{
  description = "NixOS configuration";
  inputs = {
    # self.submodules = true;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-colors,
      sops-nix,
      secrets,
      crowdsec,
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
                    cosmic-themes-base16 = prev.callPackage ./overlays/cosmic-themes-base16 { };
                  })
                ];
              }
            )
          ];
          extraInputs = {
            inherit nix-colors;
          };
          hmModules = [
            ./overlays/cosmic-themes-base16/home-manager-module.nix
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
          inherit system;
          modules = [
            # common modules
            hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            secrets.nixosModules.default
            {
              networking.hostName = "${name}";
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
              inherit system;
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
