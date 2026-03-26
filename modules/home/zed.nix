{ config, pkgs, lib, ... }:

let
  # Generate base16 theme from nix-colors with comprehensive Gruvbox-style mapping
  base16Theme = {
    name = "Base16 Custom";
    appearance = "dark"; # Will be overridden by light/dark variants
    style = {
      # Main colors
      background = "#${config.colorScheme.palette.base00}";
      foreground = "#${config.colorScheme.palette.base05}";

      # Border colors
      border = "#${config.colorScheme.palette.base03}";
      "border.variant" = "#${config.colorScheme.palette.base01}";
      "border.focused" = "#${config.colorScheme.palette.base0B}";
      "border.selected" = "#${config.colorScheme.palette.base0B}";
      "border.transparent" = null;
      "border.disabled" = null;

      # Surface colors
      "elevated_surface.background" = "#${config.colorScheme.palette.base01}";
      "surface.background" = "#${config.colorScheme.palette.base00}";

      # Element colors
      "element.background" = "#${config.colorScheme.palette.base00}";
      "element.hover" = "#${config.colorScheme.palette.base01}";
      "element.active" = "#${config.colorScheme.palette.base02}";
      "element.selected" = "#${config.colorScheme.palette.base02}";
      "element.disabled" = "#${config.colorScheme.palette.base03}d3";

      # Ghost element colors
      "ghost_element.background" = null;
      "ghost_element.hover" = "#${config.colorScheme.palette.base01}";
      "ghost_element.active" = "#${config.colorScheme.palette.base01}";
      "ghost_element.selected" = "#${config.colorScheme.palette.base01}";
      "ghost_element.disabled" = "#${config.colorScheme.palette.base03}d3";

      # Drop target
      "drop_target.background" = "#${config.colorScheme.palette.base03}d3";

      # Text colors
      text = "#${config.colorScheme.palette.base05}";
      "text.muted" = "#${config.colorScheme.palette.base04}";
      "text.placeholder" = "#${config.colorScheme.palette.base03}";
      "text.disabled" = "#${config.colorScheme.palette.base03}";
      "text.accent" = "#${config.colorScheme.palette.base0C}";

      # Icon colors
      icon = "#${config.colorScheme.palette.base05}";
      "icon.muted" = "#${config.colorScheme.palette.base03}";
      "icon.disabled" = "#${config.colorScheme.palette.base03}";
      "icon.placeholder" = "#${config.colorScheme.palette.base03}";
      "icon.accent" = "#${config.colorScheme.palette.base0C}";

      # UI elements
      "status_bar.background" = "#${config.colorScheme.palette.base00}";
      "title_bar.background" = "#${config.colorScheme.palette.base00}";
      "title_bar.inactive_background" = "#${config.colorScheme.palette.base00}";
      "toolbar.background" = "#${config.colorScheme.palette.base00}";

      # Tab bar
      "tab_bar.background" = "#${config.colorScheme.palette.base00}";
      "tab.inactive_background" = "#${config.colorScheme.palette.base00}";
      "tab.active_background" = "#${config.colorScheme.palette.base01}";

      # Search
      "search.match_background" = "#${config.colorScheme.palette.base02}";
      "search.active_match_background" = "#${config.colorScheme.palette.base02}";

      # Panel
      "panel.background" = "#${config.colorScheme.palette.base00}";
      "panel.focused_border" = null;
      "pane.focused_border" = "#${config.colorScheme.palette.base00}";

      # Scrollbar
      "scrollbar.thumb.background" = "#${config.colorScheme.palette.base01}d3";
      "scrollbar.thumb.hover_background" = "#${config.colorScheme.palette.base02}";
      "scrollbar.thumb.border" = "#00000000";
      "scrollbar.track.background" = "#00000000";
      "scrollbar.track.border" = "#00000000";

      # Editor
      "editor.foreground" = "#${config.colorScheme.palette.base05}";
      "editor.background" = "#${config.colorScheme.palette.base00}";
      "editor.gutter.background" = "#${config.colorScheme.palette.base00}";
      "editor.subheader.background" = "#${config.colorScheme.palette.base00}";
      "editor.active_line.background" = "#${config.colorScheme.palette.base01}";
      "editor.highlighted_line.background" = "#${config.colorScheme.palette.base02}";
      "editor.line_number" = "#${config.colorScheme.palette.base03}";
      "editor.active_line_number" = "#${config.colorScheme.palette.base05}";
      "editor.invisible" = "#${config.colorScheme.palette.base03}";
      "editor.wrap_guide" = "#${config.colorScheme.palette.base03}";
      "editor.active_wrap_guide" = "#${config.colorScheme.palette.base03}d3";
      "editor.document_highlight.read_background" = "#${config.colorScheme.palette.base02}d3";
      "editor.document_highlight.write_background" = "#${config.colorScheme.palette.base03}d3";

      # Selection
      "editor.selection.background" = "#${config.colorScheme.palette.base02}";
      "editor.selection.inactive_background" = "#${config.colorScheme.palette.base01}";

      # Link
      "link_text.hover" = "#${config.colorScheme.palette.base0D}";

      # Status colors with backgrounds and borders
      conflict = "#${config.colorScheme.palette.base0C}";
      "conflict.background" = "#${config.colorScheme.palette.base0C}33";
      "conflict.border" = "#${config.colorScheme.palette.base03}";

      created = "#${config.colorScheme.palette.base0B}";
      "created.background" = "#${config.colorScheme.palette.base0B}33";
      "created.border" = "#${config.colorScheme.palette.base03}";

      deleted = "#${config.colorScheme.palette.base08}";
      "deleted.background" = "#${config.colorScheme.palette.base08}33";
      "deleted.border" = "#${config.colorScheme.palette.base03}";

      error = "#${config.colorScheme.palette.base08}";
      "error.background" = "#${config.colorScheme.palette.base08}33";
      "error.border" = "#${config.colorScheme.palette.base03}";

      hidden = "#${config.colorScheme.palette.base03}";
      "hidden.background" = "#${config.colorScheme.palette.base00}33";
      "hidden.border" = "#${config.colorScheme.palette.base03}";

      hint = "#${config.colorScheme.palette.base0D}";
      "hint.background" = "#${config.colorScheme.palette.base0D}33";
      "hint.border" = "#${config.colorScheme.palette.base03}";

      ignored = "#${config.colorScheme.palette.base03}";
      "ignored.background" = "#${config.colorScheme.palette.base00}33";
      "ignored.border" = "#${config.colorScheme.palette.base03}";

      info = "#${config.colorScheme.palette.base0D}";
      "info.background" = "#${config.colorScheme.palette.base01}33";
      "info.border" = "#${config.colorScheme.palette.base03}";

      modified = "#${config.colorScheme.palette.base0A}";
      "modified.background" = "#${config.colorScheme.palette.base0A}33";
      "modified.border" = "#${config.colorScheme.palette.base03}";

      predictive = "#${config.colorScheme.palette.base0E}";
      "predictive.background" = "#${config.colorScheme.palette.base0E}33";
      "predictive.border" = "#${config.colorScheme.palette.base03}";

      renamed = "#${config.colorScheme.palette.base0D}";
      "renamed.background" = "#${config.colorScheme.palette.base0D}33";
      "renamed.border" = "#${config.colorScheme.palette.base03}";

      success = "#${config.colorScheme.palette.base0B}";
      "success.background" = "#${config.colorScheme.palette.base0B}33";
      "success.border" = "#${config.colorScheme.palette.base03}";

      unreachable = "#${config.colorScheme.palette.base03}";
      "unreachable.background" = "#${config.colorScheme.palette.base00}33";
      "unreachable.border" = "#${config.colorScheme.palette.base03}";

      warning = "#${config.colorScheme.palette.base0A}";
      "warning.background" = "#${config.colorScheme.palette.base0A}33";
      "warning.border" = "#${config.colorScheme.palette.base03}";

      # Player colors for collaboration
      players = [
        {
          cursor = "#${config.colorScheme.palette.base0D}";
          background = "#${config.colorScheme.palette.base0D}20";
          selection = "#${config.colorScheme.palette.base0D}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base0E}";
          background = "#${config.colorScheme.palette.base0E}20";
          selection = "#${config.colorScheme.palette.base0E}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base0E}";
          background = "#${config.colorScheme.palette.base0E}20";
          selection = "#${config.colorScheme.palette.base0E}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base09}";
          background = "#${config.colorScheme.palette.base09}20";
          selection = "#${config.colorScheme.palette.base09}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base0C}";
          background = "#${config.colorScheme.palette.base0C}20";
          selection = "#${config.colorScheme.palette.base0C}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base08}";
          background = "#${config.colorScheme.palette.base08}20";
          selection = "#${config.colorScheme.palette.base08}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base0A}";
          background = "#${config.colorScheme.palette.base0A}20";
          selection = "#${config.colorScheme.palette.base0A}30";
        }
        {
          cursor = "#${config.colorScheme.palette.base0B}";
          background = "#${config.colorScheme.palette.base0B}20";
          selection = "#${config.colorScheme.palette.base0B}30";
        }
      ];

      # Comprehensive syntax highlighting
      syntax = {
        attribute = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        boolean = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        comment = {
          color = "#${config.colorScheme.palette.base03}";
          font_style = "italic";
          font_weight = null;
        };
        "comment.doc" = {
          color = "#${config.colorScheme.palette.base03}";
          font_style = "italic";
          font_weight = 700;
        };
        constant = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        constructor = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        embedded = {
          color = "#${config.colorScheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        emphasis = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        "emphasis.strong" = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = 700;
        };
        enum = {
          color = "#${config.colorScheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        function = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        hint = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = null;
          font_weight = 700;
        };
        keyword = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = "italic";
          font_weight = null;
        };
        label = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        link_text = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = "normal";
          font_weight = null;
        };
        link_uri = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        number = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        operator = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        predictive = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = "italic";
          font_weight = null;
        };
        preproc = {
          color = "#${config.colorScheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        primary = {
          color = "#${config.colorScheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        property = {
          color = "#${config.colorScheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        punctuation = {
          color = "#${config.colorScheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.bracket" = {
          color = "#${config.colorScheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.delimiter" = {
          color = "#${config.colorScheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.list_marker" = {
          color = "#${config.colorScheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.special" = {
          color = "#${config.colorScheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        string = {
          color = "#${config.colorScheme.palette.base0B}";
          font_style = null;
          font_weight = null;
        };
        "string.escape" = {
          color = "#${config.colorScheme.palette.base03}";
          font_style = null;
          font_weight = null;
        };
        "string.regex" = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        "string.special" = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        "string.special.symbol" = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        tag = {
          color = "#${config.colorScheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        "text.literal" = {
          color = "#${config.colorScheme.palette.base0B}";
          font_style = null;
          font_weight = null;
        };
        title = {
          color = "#${config.colorScheme.palette.base08}";
          font_style = null;
          font_weight = 400;
        };
        type = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        variable = {
          color = "#${config.colorScheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        "variable.special" = {
          color = "#${config.colorScheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        variant = {
          color = "#${config.colorScheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
      };

      # Terminal colors
      "terminal.background" = "#${config.colorScheme.palette.base00}ff";
      "terminal.foreground" = "#${config.colorScheme.palette.base05}ff";
      "terminal.bright_foreground" = "#${config.colorScheme.palette.base05}ff";
      "terminal.dim_foreground" = "#${config.colorScheme.palette.base00}ff";

      "terminal.ansi.black" = "#${config.colorScheme.palette.base00}ff";
      "terminal.ansi.bright_black" = "#${config.colorScheme.palette.base03}ff";
      "terminal.ansi.dim_black" = "#${config.colorScheme.palette.base05}ff";

      "terminal.ansi.red" = "#${config.colorScheme.palette.base08}ff";
      "terminal.ansi.bright_red" = "#${config.colorScheme.palette.base08}ff";
      "terminal.ansi.dim_red" = "#${config.colorScheme.palette.base08}ff";

      "terminal.ansi.green" = "#${config.colorScheme.palette.base0B}ff";
      "terminal.ansi.bright_green" = "#${config.colorScheme.palette.base0B}ff";
      "terminal.ansi.dim_green" = "#${config.colorScheme.palette.base0B}ff";

      "terminal.ansi.yellow" = "#${config.colorScheme.palette.base0A}ff";
      "terminal.ansi.bright_yellow" = "#${config.colorScheme.palette.base0A}ff";
      "terminal.ansi.dim_yellow" = "#${config.colorScheme.palette.base08}ff";

      "terminal.ansi.blue" = "#${config.colorScheme.palette.base0D}ff";
      "terminal.ansi.bright_blue" = "#${config.colorScheme.palette.base0D}ff";
      "terminal.ansi.dim_blue" = "#${config.colorScheme.palette.base0D}ff";

      "terminal.ansi.magenta" = "#${config.colorScheme.palette.base0E}ff";
      "terminal.ansi.bright_magenta" = "#${config.colorScheme.palette.base0E}ff";
      "terminal.ansi.dim_magenta" = "#${config.colorScheme.palette.base0E}ff";

      "terminal.ansi.cyan" = "#${config.colorScheme.palette.base0C}ff";
      "terminal.ansi.bright_cyan" = "#${config.colorScheme.palette.base0C}ff";
      "terminal.ansi.dim_cyan" = "#${config.colorScheme.palette.base0C}ff";

      "terminal.ansi.white" = "#${config.colorScheme.palette.base05}ff";
      "terminal.ansi.bright_white" = "#${config.colorScheme.palette.base05}ff";
      "terminal.ansi.dim_white" = "#${config.colorScheme.palette.base04}ff";
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
