{
  config,
  pkgs,
  lib,
  mkScheme,
  colorParams,
  ...
}:

let
  # Generate base16 theme from nix-colors with comprehensive Gruvbox-style mapping
  base16Theme = scheme: {
    style = {
      # Main colors
      background = "#${scheme.palette.base00}";
      foreground = "#${scheme.palette.base05}";

      # Border colors
      border = "#${scheme.palette.base03}";
      "border.variant" = "#${scheme.palette.base01}";
      "border.focused" = "#${scheme.palette.base0B}";
      "border.selected" = "#${scheme.palette.base0B}";
      "border.transparent" = null;
      "border.disabled" = null;

      # Surface colors
      "elevated_surface.background" = "#${scheme.palette.base01}";
      "surface.background" = "#${scheme.palette.base00}";

      # Element colors
      "element.background" = "#${scheme.palette.base00}";
      "element.hover" = "#${scheme.palette.base01}";
      "element.active" = "#${scheme.palette.base02}";
      "element.selected" = "#${scheme.palette.base02}";
      "element.disabled" = "#${scheme.palette.base03}d3";

      # Ghost element colors
      # Popups/pickers (e.g. command palette, file finder) render on
      # elevated_surface.background (base01), so these must be a step
      # darker/lighter than that to stay visible - matching it makes the
      # keyboard-selected row invisible.
      "ghost_element.background" = null;
      "ghost_element.hover" = "#${scheme.palette.base02}";
      "ghost_element.active" = "#${scheme.palette.base02}";
      "ghost_element.selected" = "#${scheme.palette.base02}";
      "ghost_element.disabled" = "#${scheme.palette.base03}d3";

      # Drop target
      "drop_target.background" = "#${scheme.palette.base03}d3";

      # Text colors
      text = "#${scheme.palette.base05}";
      "text.muted" = "#${scheme.palette.base05}";
      "text.placeholder" = "#${scheme.palette.base04}";
      "text.disabled" = "#${scheme.palette.base04}";
      "text.accent" = "#${scheme.palette.base0C}";

      # Icon colors
      icon = "#${scheme.palette.base05}";
      "icon.muted" = "#${scheme.palette.base04}";
      "icon.disabled" = "#${scheme.palette.base04}";
      "icon.placeholder" = "#${scheme.palette.base04}";
      "icon.accent" = "#${scheme.palette.base0C}";

      # UI elements
      "status_bar.background" = "#${scheme.palette.base00}";
      "title_bar.background" = "#${scheme.palette.base00}";
      "title_bar.inactive_background" = "#${scheme.palette.base00}";
      "toolbar.background" = "#${scheme.palette.base00}";

      # Tab bar
      "tab_bar.background" = "#${scheme.palette.base00}";
      "tab.inactive_background" = "#${scheme.palette.base00}";
      "tab.active_background" = "#${scheme.palette.base01}";

      # Search
      "search.match_background" = "#${scheme.palette.base02}";
      "search.active_match_background" = "#${scheme.palette.base02}";

      # Panel
      "panel.background" = "#${scheme.palette.base00}";
      "panel.focused_border" = null;
      "pane.focused_border" = "#${scheme.palette.base00}";

      # Scrollbar
      "scrollbar.thumb.background" = "#${scheme.palette.base01}d3";
      "scrollbar.thumb.hover_background" = "#${scheme.palette.base02}";
      "scrollbar.thumb.border" = "#00000000";
      "scrollbar.track.background" = "#00000000";
      "scrollbar.track.border" = "#00000000";

      # Editor
      "editor.foreground" = "#${scheme.palette.base05}";
      "editor.background" = "#${scheme.palette.base00}";
      "editor.gutter.background" = "#${scheme.palette.base00}";
      "editor.subheader.background" = "#${scheme.palette.base00}";
      "editor.active_line.background" = "#${scheme.palette.base01}";
      "editor.highlighted_line.background" = "#${scheme.palette.base02}";
      "editor.line_number" = "#${scheme.palette.base03}";
      "editor.active_line_number" = "#${scheme.palette.base05}";
      "editor.invisible" = "#${scheme.palette.base03}";
      "editor.wrap_guide" = "#${scheme.palette.base03}";
      "editor.active_wrap_guide" = "#${scheme.palette.base03}d3";
      "editor.document_highlight.read_background" = "#${scheme.palette.base02}d3";
      "editor.document_highlight.write_background" = "#${scheme.palette.base03}d3";

      # Selection
      "editor.selection.background" = "#${scheme.palette.base02}";
      "editor.selection.inactive_background" = "#${scheme.palette.base01}";

      # Link
      "link_text.hover" = "#${scheme.palette.base0D}";

      # Status colors with backgrounds and borders
      conflict = "#${scheme.palette.base0C}";
      "conflict.background" = "#${scheme.palette.base0C}33";
      "conflict.border" = "#${scheme.palette.base03}";

      created = "#${scheme.palette.base0B}";
      "created.background" = "#${scheme.palette.base0B}33";
      "created.border" = "#${scheme.palette.base03}";

      deleted = "#${scheme.palette.base08}";
      "deleted.background" = "#${scheme.palette.base08}33";
      "deleted.border" = "#${scheme.palette.base03}";

      error = "#${scheme.palette.base08}";
      "error.background" = "#${scheme.palette.base08}33";
      "error.border" = "#${scheme.palette.base03}";

      hidden = "#${scheme.palette.base03}";
      "hidden.background" = "#${scheme.palette.base00}33";
      "hidden.border" = "#${scheme.palette.base03}";

      hint = "#${scheme.palette.base0D}";
      "hint.background" = "#${scheme.palette.base0D}33";
      "hint.border" = "#${scheme.palette.base03}";

      ignored = "#${scheme.palette.base03}";
      "ignored.background" = "#${scheme.palette.base00}33";
      "ignored.border" = "#${scheme.palette.base03}";

      info = "#${scheme.palette.base0D}";
      "info.background" = "#${scheme.palette.base01}33";
      "info.border" = "#${scheme.palette.base03}";

      modified = "#${scheme.palette.base0A}";
      "modified.background" = "#${scheme.palette.base0A}33";
      "modified.border" = "#${scheme.palette.base03}";

      predictive = "#${scheme.palette.base0E}";
      "predictive.background" = "#${scheme.palette.base0E}33";
      "predictive.border" = "#${scheme.palette.base03}";

      renamed = "#${scheme.palette.base0D}";
      "renamed.background" = "#${scheme.palette.base0D}33";
      "renamed.border" = "#${scheme.palette.base03}";

      success = "#${scheme.palette.base0B}";
      "success.background" = "#${scheme.palette.base0B}33";
      "success.border" = "#${scheme.palette.base03}";

      unreachable = "#${scheme.palette.base03}";
      "unreachable.background" = "#${scheme.palette.base00}33";
      "unreachable.border" = "#${scheme.palette.base03}";

      warning = "#${scheme.palette.base0A}";
      "warning.background" = "#${scheme.palette.base0A}33";
      "warning.border" = "#${scheme.palette.base03}";

      # Player colors for collaboration
      players = [
        {
          cursor = "#${scheme.palette.base0D}";
          background = "#${scheme.palette.base0D}20";
          selection = "#${scheme.palette.base0D}30";
        }
        {
          cursor = "#${scheme.palette.base0E}";
          background = "#${scheme.palette.base0E}20";
          selection = "#${scheme.palette.base0E}30";
        }
        {
          cursor = "#${scheme.palette.base0E}";
          background = "#${scheme.palette.base0E}20";
          selection = "#${scheme.palette.base0E}30";
        }
        {
          cursor = "#${scheme.palette.base09}";
          background = "#${scheme.palette.base09}20";
          selection = "#${scheme.palette.base09}30";
        }
        {
          cursor = "#${scheme.palette.base0C}";
          background = "#${scheme.palette.base0C}20";
          selection = "#${scheme.palette.base0C}30";
        }
        {
          cursor = "#${scheme.palette.base08}";
          background = "#${scheme.palette.base08}20";
          selection = "#${scheme.palette.base08}30";
        }
        {
          cursor = "#${scheme.palette.base0A}";
          background = "#${scheme.palette.base0A}20";
          selection = "#${scheme.palette.base0A}30";
        }
        {
          cursor = "#${scheme.palette.base0B}";
          background = "#${scheme.palette.base0B}20";
          selection = "#${scheme.palette.base0B}30";
        }
      ];

      # Comprehensive syntax highlighting
      syntax = {
        attribute = {
          color = "#${scheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        boolean = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        comment = {
          color = "#${scheme.palette.base04}";
          font_style = "italic";
          font_weight = null;
        };
        "comment.doc" = {
          color = "#${scheme.palette.base03}";
          font_style = "italic";
          font_weight = 700;
        };
        constant = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        constructor = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        embedded = {
          color = "#${scheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        emphasis = {
          color = "#${scheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        "emphasis.strong" = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = 700;
        };
        enum = {
          color = "#${scheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        function = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        hint = {
          color = "#${scheme.palette.base0D}";
          font_style = null;
          font_weight = 700;
        };
        keyword = {
          color = "#${scheme.palette.base0D}";
          font_style = "italic";
          font_weight = null;
        };
        label = {
          color = "#${scheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        link_text = {
          color = "#${scheme.palette.base0C}";
          font_style = "normal";
          font_weight = null;
        };
        link_uri = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        number = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        operator = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        predictive = {
          color = "#${scheme.palette.base0E}";
          font_style = "italic";
          font_weight = null;
        };
        preproc = {
          color = "#${scheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        primary = {
          color = "#${scheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        property = {
          color = "#${scheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        punctuation = {
          color = "#${scheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.bracket" = {
          color = "#${scheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.delimiter" = {
          color = "#${scheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.list_marker" = {
          color = "#${scheme.palette.base08}";
          font_style = null;
          font_weight = null;
        };
        "punctuation.special" = {
          color = "#${scheme.palette.base04}";
          font_style = null;
          font_weight = null;
        };
        string = {
          color = "#${scheme.palette.base0B}";
          font_style = null;
          font_weight = null;
        };
        "string.escape" = {
          color = "#${scheme.palette.base03}";
          font_style = null;
          font_weight = null;
        };
        "string.regex" = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        "string.special" = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        "string.special.symbol" = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        tag = {
          color = "#${scheme.palette.base0D}";
          font_style = null;
          font_weight = null;
        };
        "text.literal" = {
          color = "#${scheme.palette.base0B}";
          font_style = null;
          font_weight = null;
        };
        title = {
          color = "#${scheme.palette.base08}";
          font_style = null;
          font_weight = 400;
        };
        type = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
        variable = {
          color = "#${scheme.palette.base05}";
          font_style = null;
          font_weight = null;
        };
        "variable.special" = {
          color = "#${scheme.palette.base0E}";
          font_style = null;
          font_weight = null;
        };
        variant = {
          color = "#${scheme.palette.base0C}";
          font_style = null;
          font_weight = null;
        };
      };

      # Terminal colors
      "terminal.background" = "#${scheme.palette.base00}ff";
      "terminal.foreground" = "#${scheme.palette.base05}ff";
      "terminal.bright_foreground" = "#${scheme.palette.base05}ff";
      "terminal.dim_foreground" = "#${scheme.palette.base00}ff";

      "terminal.ansi.black" = "#${scheme.palette.base00}ff";
      "terminal.ansi.bright_black" = "#${scheme.palette.base03}ff";
      "terminal.ansi.dim_black" = "#${scheme.palette.base05}ff";

      "terminal.ansi.red" = "#${scheme.palette.base08}ff";
      "terminal.ansi.bright_red" = "#${scheme.palette.base08}ff";
      "terminal.ansi.dim_red" = "#${scheme.palette.base08}ff";

      "terminal.ansi.green" = "#${scheme.palette.base0B}ff";
      "terminal.ansi.bright_green" = "#${scheme.palette.base0B}ff";
      "terminal.ansi.dim_green" = "#${scheme.palette.base0B}ff";

      "terminal.ansi.yellow" = "#${scheme.palette.base0A}ff";
      "terminal.ansi.bright_yellow" = "#${scheme.palette.base0A}ff";
      "terminal.ansi.dim_yellow" = "#${scheme.palette.base08}ff";

      "terminal.ansi.blue" = "#${scheme.palette.base0D}ff";
      "terminal.ansi.bright_blue" = "#${scheme.palette.base0D}ff";
      "terminal.ansi.dim_blue" = "#${scheme.palette.base0D}ff";

      "terminal.ansi.magenta" = "#${scheme.palette.base0E}ff";
      "terminal.ansi.bright_magenta" = "#${scheme.palette.base0E}ff";
      "terminal.ansi.dim_magenta" = "#${scheme.palette.base0E}ff";

      "terminal.ansi.cyan" = "#${scheme.palette.base0C}ff";
      "terminal.ansi.bright_cyan" = "#${scheme.palette.base0C}ff";
      "terminal.ansi.dim_cyan" = "#${scheme.palette.base0C}ff";

      "terminal.ansi.white" = "#${scheme.palette.base05}ff";
      "terminal.ansi.bright_white" = "#${scheme.palette.base05}ff";
      "terminal.ansi.dim_white" = "#${scheme.palette.base04}ff";
    };
  };

  # Detect if a scheme is light or dark based on its name
  isLightTheme =
    scheme:
    let
      schemeName = lib.toLower (scheme.slug or scheme.name or "");
    in
    lib.hasInfix "latte" schemeName
    || lib.hasInfix "light" schemeName
    || schemeName == "catppuccin-latte";

  # Themes bundled with Zed itself (no extension install required). Zed only
  # ships a handful of these compared to Helix's ~150, so coverage is limited
  # to this list; everything else falls back to our generated Base16 Custom
  # theme.
  zedBuiltinThemes = [
    "One Dark"
    "One Light"
    "Gruvbox Dark"
    "Gruvbox Dark Hard"
    "Gruvbox Dark Soft"
    "Gruvbox Light"
    "Gruvbox Light Hard"
    "Gruvbox Light Soft"
    "Ayu Dark"
    "Ayu Light"
    "Ayu Mirage"
    "Andromeda"
  ];

  # nix-colors slugs are dash-separated lowercase words (e.g. "gruvbox-dark-hard",
  # "ayu-light"); Zed's built-in theme names are the same words, space-separated
  # and title-cased (e.g. "Gruvbox Dark Hard", "Ayu Light"). Convert and match.
  titleCaseWord =
    word:
    lib.toUpper (builtins.substring 0 1 word) + builtins.substring 1 (builtins.stringLength word) word;
  zedThemeNameFor =
    scheme:
    let
      schemeSlug = scheme.slug or "";
      schemeSlugTitleCased = builtins.concatStringsSep " " (
        map titleCaseWord (lib.splitString "-" schemeSlug)
      );
      matchedZedTheme = lib.findFirst (t: t == schemeSlugTitleCased) null zedBuiltinThemes;
    in
    if schemeSlug != "" && matchedZedTheme != null then
      matchedZedTheme
    else if isLightTheme scheme then
      "Base16 Custom Light"
    else
      "Base16 Custom Dark";

  # Both modes are always configured; Zed follows the system appearance, so
  # settings.json is identical across the light/dark specialisations and Zed
  # switches live without a settings reload.
  lightScheme = mkScheme colorParams.lightModeScheme;
  darkScheme = mkScheme colorParams.darkModeScheme;
in
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "helix_mode"
      "codebook"
      "toml"
      "dockerfile"
      "gleam"
      "catppuccin"
      "haskell"
      "html"
      "lean4"
      "make"
    ];

    # Helix lets a count be typed after the goto prefix: `g12g` jumps to line
    # 12. Zed has no binding for `g <digit>`, so bind each digit under `g` to
    # vim::Number. That seeds the count; further digits append through Zed's
    # normal count handling, and the closing `g g` (vim::StartOfDocument)
    # honours it. `0` is left out because a count never starts with 0.
    userKeymaps = [
      {
        context = "vim_mode == helix_normal || vim_mode == helix_select";
        bindings = lib.listToAttrs (
          map (
            n:
            lib.nameValuePair "g ${toString n}" [
              "vim::Number"
              n
            ]
          ) (lib.range 1 9)
        );
      }
    ];

    userSettings = {
      theme = {
        mode = "system";
        light = zedThemeNameFor lightScheme;
        dark = zedThemeNameFor darkScheme;
      };

      helix_mode = true;
      terminal = {
        font_family = "JetBrainsMono Nerd Font Mono";
        shell = "system";
      };
      relative_line_numbers = "wrapped";
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
      soft_wrap = "editor_width";

      outline_panel.dock = "right";
      git_panel.dock = "right";
      project_panel.dock = "right";

      telemetry = {
        metrics = false;
        diagnostics = false;
        anonymous = true;
        enabled = false;
      };

      lsp = {
        # clangd builds its own cc1 command line from the compiler arguments in
        # compile_commands.json instead of executing the compiler named there.
        # On NixOS that loses the libc headers: the Nix cc wrapper adds
        # -isystem <glibc-dev>/include through its wrapper script and
        # NIX_CFLAGS_COMPILE, neither of which clangd reproduces, and the paths
        # it does search (/usr/include, /usr/local/include, /include) hold no
        # glibc. Every <stdio.h>/<time.h> then fails to resolve, surfacing as
        # follow-on errors such as "use of undeclared identifier
        # 'CLOCK_MONOTONIC'". Starting Zed inside an FHS env does not help --
        # that /usr/include carries no libc headers either.
        #
        # --query-driver whitelists drivers clangd may run with -v -E to
        # extract their real system include paths. The globs must match the
        # driver as spelled in compile_commands.json, which for a Nix build is
        # the absolute store path of the wrapper.
        clangd.binary.arguments = [
          "--query-driver=/nix/store/*/bin/clang,/nix/store/*/bin/clang++,/nix/store/*/bin/gcc,/nix/store/*/bin/g++"
        ];
      };
    };
  };

  # Write the custom theme file
  xdg.configFile."zed/themes/base16-custom.json".text = builtins.toJSON {
    "$schema" = "https://zed.dev/schema/themes/v0.1.0.json";
    name = "Base16 Custom";
    author = "Generated from nix-colors";
    themes = [
      (
        base16Theme lightScheme
        // {
          name = "Base16 Custom Light";
          appearance = "light";
        }
      )
      (
        base16Theme darkScheme
        // {
          name = "Base16 Custom Dark";
          appearance = "dark";
        }
      )
    ];
  };
}
