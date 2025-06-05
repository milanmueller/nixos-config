{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
  ];
  home.stateVersion = "24.05";
}
