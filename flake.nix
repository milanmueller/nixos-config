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
    secrets = {
      url = "git+ssh://git@github.com/milanmueller/nixos-secrets.git";
    };
    # cosmic-themes-base16 = {
    # url = "github:milanmueller/cosmic-themes-base16";
    # url = "path:/home/milan/git/cosmic-themes-base16";
    # inputs.nixpkgs.follows = "nixpkgs";
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
    }:
    let
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
      nixosConfigurations = {
        "red-miso" = import ./hosts/red-miso {
          inherit
            nixpkgs
            home-manager
            nixos-cosmic
            flatpaks
            nix-colors
            sops-nix
            secrets
            # cosmic-themes-base16
            ;
          system = "x86_64-linux";
        };
        "monomyth" = import ./hosts/monomyth {
          inherit
            nixpkgs
            nix-colors
            home-manager
            sops-nix
            secrets
            ;
          system = "aarch64-linux";
        };
        "gestaltzerfall" = import ./hosts/gestaltzerfall {
          inherit
            nixpkgs
            nix-colors
            home-manager
            sops-nix
            secrets
            ;
          system = "x86_64-linux";
        };
        "odessa" = import ./hosts/odessa {
          inherit
            nixpkgs
            nix-colors
            home-manager
            sops-nix
            secrets
            ;
          system = "aarch64-linux";
        };
      };
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
