{ config, pkgs, ... }:
{
  # Home Manager Settings
  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # home-manager.extraSpecialArgs.flake-inputs = inputs;
}
