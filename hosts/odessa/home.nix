{
  config,
  pkgs,
  inputs,
  nix-colors,
  ...
}:
{
  imports = [
    ../../modules/home/helix.nix
    ../../modules/home/nushell.nix
    ../../modules/home/git.nix
  ];

  # Basics
  home.username = "milan";
  home.homeDirectory = "/home/milan";
  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
