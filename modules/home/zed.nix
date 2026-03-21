{ config, pkgs, lib, ... }:

let
  # Generate base16 theme from nix-colors
  base16Theme = {
    name = "Base16 Custom";
    appearance = "dark"; # Will be overridden by light/dark variants
    style = {
      background = "#${config.colorScheme.palette.base00}";
      foreground = "#${config.colorScheme.palette.base05}";

      # UI colors
      "editor.background" = "#${config.colorScheme.palette.base00}";
      "editor.foreground" = "#${config.colorScheme.palette.base05}";
      "editor.gutter.background" = "#${config.colorScheme.palette.base00}";
      "editor.line_number" = "#${config.colorScheme.palette.base03}";
      "editor.active_line_number" = "#${config.colorScheme.palette.base0A}";
      "editor.active_line.background" = "#${config.colorScheme.palette.base01}";

      # Selection
      "editor.selection.background" = "#${config.colorScheme.palette.base02}";

      # UI elements
      "panel.background" = "#${config.colorScheme.palette.base01}";
      "status_bar.background" = "#${config.colorScheme.palette.base02}";
      "title_bar.background" = "#${config.colorScheme.palette.base02}";
      "toolbar.background" = "#${config.colorScheme.palette.base01}";

      # Tab bar
      "tab_bar.background" = "#${config.colorScheme.palette.base01}";
      "tab.active_background" = "#${config.colorScheme.palette.base02}";
      "tab.inactive_background" = "#${config.colorScheme.palette.base01}";

      # Text colors
      text = "#${config.colorScheme.palette.base05}";
      "text.muted" = "#${config.colorScheme.palette.base03}";
      "text.accent" = "#${config.colorScheme.palette.base0D}";

      # Syntax highlighting
      comment = {
        color = "#${config.colorScheme.palette.base03}";
        font_style = "italic";
      };

      string = "#${config.colorScheme.palette.base0B}";
      number = "#${config.colorScheme.palette.base09}";
      boolean = "#${config.colorScheme.palette.base09}";

      keyword = "#${config.colorScheme.palette.base0E}";
      "keyword.control" = "#${config.colorScheme.palette.base08}";

      function = "#${config.colorScheme.palette.base0D}";
      "function.method" = "#${config.colorScheme.palette.base0D}";

      type = "#${config.colorScheme.palette.base0A}";
      variable = "#${config.colorScheme.palette.base05}";
      "variable.parameter" = "#${config.colorScheme.palette.base08}";

      constant = "#${config.colorScheme.palette.base09}";
      operator = "#${config.colorScheme.palette.base0C}";

      # Markup
      "markup.heading" = "#${config.colorScheme.palette.base0D}";
      "markup.bold" = {
        color = "#${config.colorScheme.palette.base0A}";
        font_style = "bold";
      };
      "markup.italic" = {
        color = "#${config.colorScheme.palette.base0E}";
        font_style = "italic";
      };
      "markup.link" = "#${config.colorScheme.palette.base0D}";

      # Diagnostics
      error = "#${config.colorScheme.palette.base08}";
      warning = "#${config.colorScheme.palette.base0A}";
      info = "#${config.colorScheme.palette.base0C}";
      hint = "#${config.colorScheme.palette.base0D}";
    };
  };

  # Detect if the current theme is light or dark based on scheme name
  isLightTheme =
    let
      schemeName = lib.toLower (config.colorScheme.slug or config.colorScheme.name or "");
    in
    lib.hasInfix "latte" schemeName
    || lib.hasInfix "light" schemeName
    || schemeName == "catppuccin-latte";

in {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "helix_mode"
      "codebook"
    ];

    userSettings = {
      theme = "Base16 Custom";

      helix_mode = true;
      terminal = {
        font_family = "JetBrainsMono Nerd Font Mono";
        shell = "system";
      };
      relative_line_numbers = true;
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
    };
  };

  # Write the custom theme file
  xdg.configFile."zed/themes/base16-custom.json".text = builtins.toJSON {
    "$schema" = "https://zed.dev/schema/themes/v0.1.0.json";
    name = "Base16 Custom";
    author = "Generated from nix-colors";
    themes = [
      (base16Theme // {
        name = "Base16 Custom";
        appearance = if isLightTheme then "light" else "dark";
      })
    ];
  };
}
