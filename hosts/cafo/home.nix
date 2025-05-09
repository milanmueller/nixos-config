{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
  ];
  home.stateVersion = "24.05";
}
