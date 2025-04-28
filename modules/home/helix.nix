{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:
{
  imports = [
    ./colors.nix # requires colors for custom theme
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "▏";
          skip-levels = 0;
        };
      };
      # theme = "base16_custom";
      theme = "catppuccin_latte";
    };
    languages = {
      language-server = {
        # Language Servers
        haskell-language-server = {
          command = "haskell-language-server-wrapper";
          args = [ "--lsp" ];
        };
      };
      # Language Config
      language = lib.mkDefault (import ./helix-languages.nix { inherit lib pkgs; }).languages;
    };
    # Base16 Theme
    themes = {
      base16_custom = {
        "annotation" = {
          fg = "fg1";
        };
        "attribute" = {
          fg = "aqua1";
          modifiers = [ "italic" ];
        };
        "comment" = {
          fg = "gray";
          modifiers = [ "italic" ];
        };
        "constant" = {
          fg = "purple1";
        };
        "constant.character" = {
          fg = "aqua1";
        };
        "constant.character.escape" = {
          fg = "orange1";
        };
        "constant.macro" = {
          fg = "aqua1";
        };
        "constructor" = {
          fg = "purple1";
        };
        "definition" = {
          underline = {
            color = "aqua1";
          };
        };
        "diagnostic" = {
          underline = {
            color = "orange1";
            style = "curl";
          };
        };
        "diagnostic.deprecated" = {
          modifiers = [ "crossed_out" ];
        };
        "diagnostic.error" = {
          underline = {
            color = "red1";
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = "blue1";
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "aqua1";
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = "yellow1";
            style = "curl";
          };
        };
        # "diagnostic.unnecessary" = { modifiers = ["dim"] }  # do not remove this for future resolving
        "error" = {
          fg = "red1";
        };
        "hint" = {
          fg = "blue1";
        };
        "info" = {
          fg = "aqua1";
        };
        "warning" = {
          fg = "yellow1";
        };
        "diff.delta" = {
          fg = "yellow1";
        };
        "diff.minus" = {
          fg = "red1";
        };
        "diff.plus" = {
          fg = "green1";
        };
        "function" = {
          fg = "green1";
        };
        "function.builtin" = {
          fg = "yellow1";
        };
        "function.macro" = {
          fg = "blue1";
        };
        "keyword" = {
          fg = "red1";
        };
        "keyword.control.import" = {
          fg = "aqua1";
        };
        "label" = {
          fg = "red1";
        };
        "markup.bold" = {
          modifiers = [ "bold" ];
        };
        "markup.heading" = "aqua1";
        "markup.italic" = {
          modifiers = [ "italic" ];
        };
        "markup.link.text" = "red1";
        "markup.link.url" = {
          fg = "green1";
          modifiers = [ "underlined" ];
        };
        "markup.raw" = "red1";
        "markup.strikethrough" = {
          modifiers = [ "crossed_out" ];
        };
        "module" = {
          fg = "aqua1";
        };
        "namespace" = {
          fg = "fg1";
        };
        "operator" = {
          fg = "purple1";
        };
        "punctuation" = {
          fg = "orange1";
        };
        "special" = {
          fg = "purple0";
        };
        "string" = {
          fg = "green1";
        };
        "string.regexp" = {
          fg = "orange1";
        };
        "string.special" = {
          fg = "orange1";
        };
        "string.symbol" = {
          fg = "yellow1";
        };
        "tag" = {
          fg = "aqua1";
        };
        "type" = {
          fg = "yellow1";
        };
        "type.enum.variant" = {
          modifiers = [ "italic" ];
        };
        "ui.background" = {
          bg = "bg0";
        };
        "ui.bufferline" = {
          fg = "fg1";
          bg = "bg1";
        };
        "ui.bufferline.active" = {
          fg = "bg0";
          bg = "yellow0";
        };
        "ui.bufferline.background" = {
          bg = "bg2";
        };
        "ui.cursor" = {
          fg = "bg1";
          bg = "bg2";
        };
        "ui.cursor.insert" = {
          fg = "bg1";
          bg = "blue0";
        };
        "ui.cursor.normal" = {
          fg = "bg1";
          bg = "gray";
        };
        "ui.cursor.select" = {
          fg = "bg1";
          bg = "orange0";
        };
        "ui.cursor.match" = {
          fg = "fg3";
          bg = "bg3";
        };
        "ui.cursor.primary" = {
          bg = "fg3";
          fg = "bg1";
        };
        "ui.cursor.primary.insert" = {
          fg = "bg1";
          bg = "blue1";
        };
        "ui.cursor.primary.normal" = {
          fg = "bg1";
          bg = "fg3";
        };
        "ui.cursor.primary.select" = {
          fg = "bg1";
          bg = "orange1";
        };
        "ui.cursorline" = {
          bg = "bg0_s";
        };
        "ui.cursorline.primary" = {
          bg = "bg1";
        };
        "ui.help" = {
          bg = "bg1";
          fg = "fg1";
        };
        "ui.linenr" = {
          fg = "bg3";
        };
        "ui.linenr.selected" = {
          fg = "yellow1";
        };
        "ui.menu" = {
          fg = "fg1";
          bg = "bg2";
        };
        "ui.menu.selected" = {
          fg = "bg2";
          bg = "blue1";
          modifiers = [ "bold" ];
        };
        "ui.popup" = {
          bg = "bg1";
        };
        "ui.picker.header.column" = {
          underline.style = "line";
        };
        "ui.picker.header.column.active" = {
          modifiers = [ "bold" ];
          underline.style = "line";
        };
        "ui.selection" = {
          bg = "bg1";
        };
        "ui.selection.primary" = {
          bg = "bg2";
        };
        "ui.statusline" = {
          fg = "fg1";
          bg = "bg2";
        };
        "ui.statusline.inactive" = {
          fg = "fg4";
          bg = "bg2";
        };
        "ui.statusline.insert" = {
          fg = "bg1";
          bg = "blue1";
          modifiers = [ "bold" ];
        };
        "ui.statusline.normal" = {
          fg = "bg1";
          bg = "fg3";
          modifiers = [ "bold" ];
        };
        "ui.statusline.select" = {
          fg = "bg1";
          bg = "orange1";
          modifiers = [ "bold" ];
        };
        "ui.text" = {
          fg = "fg1";
        };
        "ui.virtual.inlay-hint" = {
          fg = "gray";
        };
        "ui.virtual.jump-label" = {
          fg = "purple0";
          modifiers = [ "bold" ];
        };
        "ui.virtual.ruler" = {
          bg = "bg1";
        };
        "ui.virtual.whitespace" = "bg2";
        "ui.virtual.wrap" = {
          fg = "bg2";
        };
        "ui.window" = {
          bg = "bg1";
        };
        "variable" = {
          fg = "fg1";
        };
        "variable.builtin" = {
          fg = "orange1";
          modifiers = [ "italic" ];
        };
        "variable.other.member" = {
          fg = "blue1";
        };
        "variable.parameter" = {
          fg = "blue1";
          modifiers = [ "italic" ];
        };

        "palette" = {

          bg0 = "#${config.colorScheme.palette.base00}"; # main background
          bg0_s = "#${config.colorScheme.palette.base01}";
          bg1 = "#${config.colorScheme.palette.base01}";
          bg2 = "#${config.colorScheme.palette.base02}";
          bg3 = "#${config.colorScheme.palette.base03}";
          bg4 = "#${config.colorScheme.palette.base03}";
          fg0 = "#${config.colorScheme.palette.base07}";
          fg1 = "#${config.colorScheme.palette.base06}"; # main foreground
          fg2 = "#${config.colorScheme.palette.base05}";
          fg3 = "#${config.colorScheme.palette.base04}";
          fg4 = "#${config.colorScheme.palette.base04}";
          gray = "#${config.colorScheme.palette.base04}";
          red0 = "#${config.colorScheme.palette.base08}"; # neutral
          red1 = "#${config.colorScheme.palette.base08}"; # bright
          green0 = "#${config.colorScheme.palette.base0B}";
          green1 = "#${config.colorScheme.palette.base0B}";
          yellow0 = "#${config.colorScheme.palette.base0A}";
          yellow1 = "#${config.colorScheme.palette.base0A}";
          blue0 = "#${config.colorScheme.palette.base0D}";
          blue1 = "#${config.colorScheme.palette.base0D}";
          purple0 = "#${config.colorScheme.palette.base0E}";
          purple1 = "#${config.colorScheme.palette.base0E}";
          aqua0 = "#${config.colorScheme.palette.base0C}";
          aqua1 = "#${config.colorScheme.palette.base0C}";
          orange0 = "#${config.colorScheme.palette.base09}";
          orange1 = "#${config.colorScheme.palette.base09}";
        };
      };
    };
  };
}
