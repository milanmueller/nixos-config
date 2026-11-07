{
  pkgs,
  osConfig,
  ...
}:
{
  # Toggle script to switch between themes. The two modes are NixOS
  # specialisations (modules/theme-mode.nix), so this is a runtime switch of
  # the active generation: no repo edit and no rebuild.
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "tt";
      text = ''
        CURRENT="${osConfig.theme.mode}"

        if [ "$CURRENT" = "light" ]; then
          NEW_MODE="dark"
        else
          NEW_MODE="light"
        fi

        echo "Switching to $NEW_MODE theme..."
        sudo /nix/var/nix/profiles/system/specialisation/"$NEW_MODE"/bin/switch-to-configuration switch

        echo "✓ Theme switched to $NEW_MODE"
      '';
    })
  ];
}
