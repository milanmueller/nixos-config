{
  nixpkgs,
  home-manager,
  nix-colors,
  sops-nix,
  system,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    secrets.nixosModules.default
    {
      home-manager = {
        extraSpecialArgs = {
          inherit nix-colors;
        };
        users.milan.imports = [
          nix-colors.homeManagerModules.default
          ./home.nix
        ];
      };
    }
  ];
}
