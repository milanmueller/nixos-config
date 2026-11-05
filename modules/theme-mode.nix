# Light/dark mode as NixOS specialisations, so toggling is a runtime switch of
# the active generation instead of an edit of a file in the repo.
{ config, lib, pkgs, ... }:
{
  options.theme.mode = lib.mkOption {
    type = lib.types.enum [
      "light"
      "dark"
    ];
    default = "light";
    description = "Active theme mode. Read by home-manager via osConfig.theme.mode.";
  };

  config = {
    specialisation = lib.genAttrs [ "light" "dark" ] (mode: {
      configuration.theme.mode = mode;
    });

    # Lets `rebuild` find the mode of the running system.
    environment.etc."theme-mode".text = config.theme.mode;

    # nixos-rebuild activates the base (light) system by default; this keeps
    # the currently active mode instead.
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "rebuild" ''
        MODE=$(cat /etc/theme-mode)
        exec sudo nixos-rebuild "''${1:-switch}" --specialisation "$MODE" "''${@:2}"
      '')
    ];
  };
}
