# Default home config for all hosts
{ config, pkgs, ... }:
{
  imports = [
    ./user.nix
    ./nushell.nix
    ./git.nix
    ./helix.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
