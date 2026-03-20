{
  pkgs,
  config,
  ...
}:
let
  # State file location
  stateFile = "${config.home.homeDirectory}/.config/theme-mode";
in
{
  # Toggle script to switch between themes
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = [ coreutils ];
      text = ''
        STATE_FILE="${stateFile}"

        # Create config dir if it doesn't exist
        mkdir -p "$(dirname "$STATE_FILE")"

        # Read current theme or default to light
        if [ -f "$STATE_FILE" ]; then
          CURRENT=$(cat "$STATE_FILE" | tr -d '[:space:]')
        else
          CURRENT="light"
        fi

        # Toggle theme
        if [ "$CURRENT" = "light" ]; then
          NEW_MODE="dark"
          echo "Switching to dark theme..."
        else
          NEW_MODE="light"
          echo "Switching to light theme..."
        fi

        # Write new mode to state file (no newline, just the mode)
        echo -n "$NEW_MODE" > "$STATE_FILE"

        # Rebuild NixOS configuration
        echo "Rebuilding system configuration..."
        sudo nixos-rebuild switch
      '';
    })
  ];
}
