{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Install Packages
  home.packages = with pkgs; [
    claude-code
  ];
  home.stateVersion = "24.05";
}
