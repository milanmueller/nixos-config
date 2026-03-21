{
  pkgs,
  config,
  colorParams,
  ...
}:
let
  # State file location from colorParams
  stateFile = "${config.home.homeDirectory}/${colorParams.stateFile}";
  # Color parameters file in the flake
  colorParamsFile = "/home/milan/nixos-config/hosts/red-miso/color-parameters.nix";
in
{
  # Toggle script to switch between themes
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = [ coreutils gnused ];
      text = ''
        COLOR_PARAMS_FILE="${colorParamsFile}"
        STATE_FILE="${stateFile}"

        # Read current mode from color-parameters.nix
        CURRENT="${colorParams.currentMode}"

        # Toggle theme
        if [ "$CURRENT" = "light" ]; then
          NEW_MODE="dark"
          echo "Switching to dark theme..."
        else
          NEW_MODE="light"
          echo "Switching to light theme..."
        fi

        # Update the color-parameters.nix file
        echo "Updating $COLOR_PARAMS_FILE..."
        sed -i "s/currentMode = \"$CURRENT\";/currentMode = \"$NEW_MODE\";/" "$COLOR_PARAMS_FILE"

        # Also write to state file for reference
        mkdir -p "$(dirname "$STATE_FILE")"
        echo -n "$NEW_MODE" > "$STATE_FILE"

        # Rebuild NixOS configuration
        echo "Rebuilding system configuration..."
        sudo nixos-rebuild switch
      '';
    })
  ];
}
