{
  config,
  pkgs,
  inputs,
  nix-colors,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
  ];
  home.stateVersion = "24.05";
}
