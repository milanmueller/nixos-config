# Default home config for all hosts
{
  pkgs,
  nix-colors,
  ...
}:
{
  imports = [
    ./user.nix
    # ./nushell.nix
    ./zsh.nix
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

  # Install uutils coreutils (Rust reimplementation of GNU coreutils)
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    delta
  ];
}
