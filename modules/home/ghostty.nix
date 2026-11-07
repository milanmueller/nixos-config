{
  userConfig,
  nix-colors,
  colorParams,
  ...
}:
let
  # Ghostty theme from a base16 scheme (standard base16 terminal mapping)
  mkTheme =
    scheme:
    let
      p = scheme.palette;
    in
    {
      background = p.base00;
      foreground = p.base05;
      cursor-color = p.base05;
      selection-background = p.base02;
      selection-foreground = p.base05;
      palette = [
        "0=#${p.base00}"
        "1=#${p.base08}"
        "2=#${p.base0B}"
        "3=#${p.base0A}"
        "4=#${p.base0D}"
        "5=#${p.base0E}"
        "6=#${p.base0C}"
        "7=#${p.base05}"
        "8=#${p.base03}"
        "9=#${p.base08}"
        "10=#${p.base0B}"
        "11=#${p.base0A}"
        "12=#${p.base0D}"
        "13=#${p.base0E}"
        "14=#${p.base0C}"
        "15=#${p.base07}"
        # base16 extras, as set via OSC in zsh.nix for other terminals
        "16=#${p.base09}"
        "17=#${p.base0F}"
        "18=#${p.base01}"
        "19=#${p.base02}"
        "20=#${p.base04}"
        "21=#${p.base06}"
      ];
    };
in
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    # Both variants are always installed; ghostty picks one from the desktop's
    # light/dark preference, which tt flips via COSMIC's is_dark.
    # That way running windows follow the toggle without a reload.
    themes = {
      base16-light = mkTheme nix-colors.colorSchemes.${colorParams.lightModeScheme};
      base16-dark = mkTheme nix-colors.colorSchemes.${colorParams.darkModeScheme};
    };
    settings = {
      theme = "light:base16-light,dark:base16-dark";
      window-decoration = "none";
      working-directory = userConfig.homeDir;
      desktop-notifications = false;
      keybind = [
        "alt+h=goto_split:left"
        "alt+j=goto_split:down"
        "alt+k=goto_split:up"
        "alt+l=goto_split:right"
      ];
    };
  };
}
