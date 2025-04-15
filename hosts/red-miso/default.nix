{
  nixpkgs,
  home-manager,
  nixos-cosmic,
  flatpaks,
  nix-colors,
  # cosmic-themes-base16,
  sops-nix,
  system,
  secrets,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    nixos-cosmic.nixosModules.default
    secrets.nixosModules.default
    {
      home-manager.extraSpecialArgs = {
        # inherit nix-colors cosmic-themes-base16 flatpaks;
        inherit nix-colors flatpaks;
      };
      home-manager.users.milan.imports = [
        ./home.nix
        nix-colors.homeManagerModules.default
      ];
    }
  ];
}
