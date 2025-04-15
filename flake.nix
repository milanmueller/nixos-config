{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets.url = "git+ssh://git@github.com/milanmueller/nixos-secrets.git";
    # cosmic-themes-base16 = {
    #   url = "github:milanmueller/cosmic-themes-base16";
    #   url = "path:/home/milan/git/cosmic-themes-base16";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-cosmic,
      flatpaks,
      nix-colors,
      sops-nix,
      secrets,
      # cosmic-themes-base16,
      ...
    }@inputs:
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
            nixos-cosmic.nixosModules.default
          ];
          extraInputs = { inherit nixos-cosmic nix-colors; };
        };
        monomyth = {
          inherit userConfig;
          system = "aarch64-linux";
          extraModules = [ ];
          extraInputs = { inherit nix-colors; };
        };
        odessa = {
          inherit userConfig;
          system = "aarch64-linux";
          extraModules = [ ];
          extraInputs = { inherit nix-colors; };
        };
        gestaltzerfall = {
          inherit userConfig;
          system = "x86_64-linux";
          extraModules = [ ];
          extraInputs = { inherit nix-colors; };
        };
      };
      mkHost =
        name:
        {
          system,
          extraModules,
          extraInputs,
          userConfig,
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
              home-manager.users.${userConfig.username}.imports = [
                hosts/${name}/home.nix
                nix-colors.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = { inherit nix-colors userConfig; };
            }
          ] ++ extraModules;
          specialArgs = {
            inherit userConfig;
          } // extraInputs;
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
          default = pkgs.mkShell {
            buildInput = [
              pkgs.nushell
            ];
            shellHook = ''
              export SHELL=${pkgs.nushell}/bin/nu

              # Welcome message
              echo "Welcome to the NixOS config environment"
            '';
          };
        }
      );
    };
}
