{
  config,
  lib,
  pkgs,
  nix-colors,
  colorParams,
  ...
}:
let
  # State file location from colorParams
  stateFile = "${config.home.homeDirectory}/${colorParams.stateFile}";

  # Get color schemes from colorParams
  lightScheme = nix-colors.colorSchemes.${colorParams.lightModeScheme};
  darkScheme = nix-colors.colorSchemes.${colorParams.darkModeScheme};

in
{
  # Disable the default cosmic-themes-base16 module
  programs.cosmic-themes-base16.enable = false;

  # Install cosmic-themes-base16 package
  home.packages = [ pkgs.cosmic-themes-base16 ];

  # Note: colorScheme is set in modules/home/defaults.nix
  # COSMIC theme is changed dynamically at activation time based on state file

  # Custom activation script that reads theme mode at runtime
  home.activation.generateCosmicTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    LOG_FILE="${config.home.homeDirectory}/.hm-cosmic.log"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting COSMIC theme generation" >> "$LOG_FILE"

    # Read theme mode from state file at activation time
    if [ -f "${stateFile}" ]; then
      THEME_MODE=$(cat "${stateFile}" | tr -d '[:space:]')
    else
      THEME_MODE="light"
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Detected theme mode: $THEME_MODE" >> "$LOG_FILE"

    # Set palette and paths based on mode
    if [ "$THEME_MODE" = "dark" ]; then
      THEME_NAME="Dark"
      IS_DARK="true"
      # Dracula colors (without # prefix)
      BASE00="${darkScheme.palette.base00}"
      BASE01="${darkScheme.palette.base01}"
      BASE02="${darkScheme.palette.base02}"
      BASE03="${darkScheme.palette.base03}"
      BASE04="${darkScheme.palette.base04}"
      BASE05="${darkScheme.palette.base05}"
      BASE06="${darkScheme.palette.base06}"
      BASE07="${darkScheme.palette.base07}"
      BASE08="${darkScheme.palette.base08}"
      BASE09="${darkScheme.palette.base09}"
      BASE0A="${darkScheme.palette.base0A}"
      BASE0B="${darkScheme.palette.base0B}"
      BASE0C="${darkScheme.palette.base0C}"
      BASE0D="${darkScheme.palette.base0D}"
      BASE0E="${darkScheme.palette.base0E}"
      BASE0F="${darkScheme.palette.base0F}"
    else
      THEME_NAME="Light"
      IS_DARK="false"
      # Catppuccin Latte colors (without # prefix)
      BASE00="${lightScheme.palette.base00}"
      BASE01="${lightScheme.palette.base01}"
      BASE02="${lightScheme.palette.base02}"
      BASE03="${lightScheme.palette.base03}"
      BASE04="${lightScheme.palette.base04}"
      BASE05="${lightScheme.palette.base05}"
      BASE06="${lightScheme.palette.base06}"
      BASE07="${lightScheme.palette.base07}"
      BASE08="${lightScheme.palette.base08}"
      BASE09="${lightScheme.palette.base09}"
      BASE0A="${lightScheme.palette.base0A}"
      BASE0B="${lightScheme.palette.base0B}"
      BASE0C="${lightScheme.palette.base0C}"
      BASE0D="${lightScheme.palette.base0D}"
      BASE0E="${lightScheme.palette.base0E}"
      BASE0F="${lightScheme.palette.base0F}"
    fi

    THEME_PATH="${config.home.homeDirectory}/.config/cosmic/com.system76.CosmicTheme.$THEME_NAME/v1"
    MODE_CONFIG_PATH="${config.home.homeDirectory}/.config/cosmic/com.system76.CosmicTheme.Mode/v1"

    # Generate the COSMIC theme
    COSMIC_CMD="${pkgs.cosmic-themes-base16}/bin/cosmic-themes-base16 $THEME_MODE $THEME_PATH #$BASE00 #$BASE01 #$BASE02 #$BASE03 #$BASE04 #$BASE05 #$BASE06 #$BASE07 #$BASE08 #$BASE09 #$BASE0A #$BASE0B #$BASE0C #$BASE0D #$BASE0E #$BASE0F --wallpaper ${./wallpaper.png}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running: $COSMIC_CMD" >> "$LOG_FILE"
    run $COSMIC_CMD >> "$LOG_FILE" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Theme generation completed" >> "$LOG_FILE"

    # Update the COSMIC theme mode toggle
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating mode config directory: $MODE_CONFIG_PATH" >> "$LOG_FILE"
    run mkdir -p "$MODE_CONFIG_PATH" >> "$LOG_FILE" 2>&1

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Setting is_dark to $IS_DARK" >> "$LOG_FILE"
    run echo -n "$IS_DARK" > "$MODE_CONFIG_PATH/is_dark" 2>> "$LOG_FILE"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Disabling auto_switch" >> "$LOG_FILE"
    run echo -n "false" > "$MODE_CONFIG_PATH/auto_switch" 2>> "$LOG_FILE"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] COSMIC theme configuration completed" >> "$LOG_FILE"
  '';
}
