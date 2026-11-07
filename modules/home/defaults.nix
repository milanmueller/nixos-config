# Default home config for all hosts
{
  pkgs,
  mkScheme,
  ...
}:
{
  imports = [
    ./user.nix
    # ./nushell.nix
    ./zsh.nix
    ./git.nix
    ./helix.nix
    ./welcome.nix
    ./zellij.nix
    ./parb.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  # Default light color scheme
  colorScheme = mkScheme "catppuccin-latte";
  # Let home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install uutils coreutils (Rust reimplementation of GNU coreutils)
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    delta
    ripgrep
  ];
}
