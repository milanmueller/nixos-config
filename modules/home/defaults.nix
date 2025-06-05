# Default home config for all hosts
{
  config,
  pkgs,
  nix-colors,
  ...
}:
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
  # Default light color scheme
  colorScheme = nix-colors.colorSchemes.catppuccin-latte;
  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
