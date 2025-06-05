{
  pkgs,
  lib,
  nix-colors,
  ...
}:
{
  specialisation.dark-theme.configuration = {
    colorScheme = lib.mkForce nix-colors.colorSchemes.dracula;
  };
  home.packages = with pkgs; [
    (hiPrio (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = with pkgs; [
        home-manager
        coreutils
        ripgrep
      ];
      text = ''
        "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
      '';
    }))
  ];
}
