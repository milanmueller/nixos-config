{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
  ];
  # Install Packages
  home.packages = with pkgs; [
    claude-code
  ];
  home.stateVersion = "24.05";
}
