{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:
let
  # Themes bundled with Helix (helix-editor/helix runtime/themes/*.toml) whose
  # names happen to line up with a nix-colors scheme slug. Used to prefer
  # Helix's own hand-tuned theme over our generated base16_custom one when the
  # selected color scheme has a native Helix equivalent.
  helixBuiltinThemes = [
    "acme"
    "adwaita-dark"
    "adwaita-light"
    "amberwood"
    "ao"
    "ashen"
    "ataraxia"
    "autumn"
    "autumn_night"
    "ayu_dark"
    "ayu_evolve"
    "ayu_light"
    "ayu_mirage"
    "base16_default_dark"
    "base16_default_light"
    "base16_terminal"
    "base16_transparent"
    "beans"
    "bogster"
    "bogster_light"
    "boo_berry"
    "carbon"
    "carbonfox"
    "catppuccin_frappe"
    "catppuccin_latte"
    "catppuccin_macchiato"
    "catppuccin_mocha"
    "curzon"
    "cyan_light"
    "darcula"
    "darcula-solid"
    "dark_high_contrast"
    "dark_plus"
    "dark-synthwave"
    "doom_acario_dark"
    "doom-one"
    "dracula"
    "dracula_at_night"
    "earl_grey"
    "eiffel"
    "emacs"
    "everblush"
    "everforest_dark"
    "everforest_light"
    "ferra"
    "flatwhite"
    "fleet_dark"
    "flexoki_dark"
    "flexoki_light"
    "focus_nova"
    "github_dark"
    "github_dark_colorblind"
    "github_dark_dimmed"
    "github_dark_high_contrast"
    "github_dark_tritanopia"
    "github_light"
    "github_light_colorblind"
    "github_light_high_contrast"
    "github_light_tritanopia"
    "gruber-darker"
    "gruvbox"
    "gruvbox_dark_hard"
    "gruvbox_dark_soft"
    "gruvbox_light"
    "gruvbox_light_hard"
    "gruvbox_light_soft"
    "gruvbox-material"
    "heisenberg"
    "hex_lavender"
    "hex_poison"
    "hex_steel"
    "hex_toxic"
    "horizon-dark"
    "iceberg-dark"
    "iceberg-light"
    "ingrid"
    "iroaseta"
    "jellybeans"
    "jetbrains_dark"
    "kanagawa"
    "kanagawa-dragon"
    "kaolin-dark"
    "kaolin-light"
    "kaolin-valley-dark"
    "kinda_nvim"
    "kinda_nvim_light"
    "lapis_aquamarine"
    "material_darker"
    "material_deep_ocean"
    "material_oceanic"
    "material_palenight"
    "meliora"
    "mellow"
    "merionette"
    "modus_operandi"
    "modus_operandi_deuteranopia"
    "modus_operandi_tinted"
    "modus_operandi_tritanopia"
    "modus_vivendi"
    "modus_vivendi_deuteranopia"
    "modus_vivendi_tinted"
    "modus_vivendi_tritanopia"
    "molokai"
    "monokai"
    "monokai_aqua"
    "monokai_pro"
    "monokai_pro_machine"
    "monokai_pro_octagon"
    "monokai_pro_ristretto"
    "monokai_pro_spectrum"
    "monokai_soda"
    "naysayer"
    "new_moon"
    "nightfox"
    "night_owl"
    "noctis"
    "noctis_bordo"
    "nord"
    "nord_light"
    "nord-night"
    "nyxvamp-obsidian"
    "nyxvamp-radiance"
    "nyxvamp-veil"
    "onedark"
    "onedarker"
    "onelight"
    "papercolor-dark"
    "papercolor-light"
    "peachpuff"
    "penumbra+"
    "poimandres"
    "poimandres_storm"
    "pop-dark"
    "rasmus"
    "rose_pine"
    "rose_pine_dawn"
    "rose_pine_moon"
    "seoul256-dark"
    "seoul256-dark-hard"
    "seoul256-dark-soft"
    "seoul256-light"
    "seoul256-light-hard"
    "seoul256-light-soft"
    "serika-dark"
    "serika-light"
    "sidra"
    "snazzy"
    "solarized_dark"
    "solarized_light"
    "sonokai"
    "spacebones_light"
    "starlight"
    "sunset"
    "term16_dark"
    "term16_light"
    "tokyonight"
    "tokyonight_day"
    "tokyonight_moon"
    "tokyonight_storm"
    "ttox"
    "varua"
    "vesper"
    "vim_dark_high_contrast"
    "vintage"
    "voxed"
    "yellowed"
    "yo"
    "yo_berry"
    "yo_light"
    "zed_onedark"
    "zed_onelight"
    "zenburn"
  ];

  # nix-colors schemes are always slugged with dashes (e.g. "gruvbox-dark-hard",
  # "ayu-light"), but Helix's bundled theme files spell some of those with
  # underscores instead (e.g. "gruvbox_dark_hard", "catppuccin_latte") and
  # others with the same dashes (e.g. "nord-night", "papercolor-dark"). Try
  # both spellings against the current scheme slug before giving up.
  schemeSlug = config.colorScheme.slug or "";
  schemeSlugUnderscored = lib.replaceStrings [ "-" ] [ "_" ] schemeSlug;
  matchedHelixTheme = lib.findFirst (
    t: t == schemeSlug || t == schemeSlugUnderscored
  ) null helixBuiltinThemes;
  helixTheme = if schemeSlug != "" && matchedHelixTheme != null then matchedHelixTheme else "base16_custom";
in
{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        soft-wrap.enable = true;
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
      theme = helixTheme;
    };
    languages = {
      # Language Config
      language = lib.mkDefault (import ./helix-languages.nix { inherit lib pkgs; }).languages;
      language-server = (import ./helix-languages.nix { inherit lib pkgs; }).language-server;
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
          fg = "bg2";
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
          bg = "bg2";
        };
        "ui.selection.primary" = {
          bg = "bg3";
        };
        "ui.statusline" = {
          fg = "bg0";
          bg = "aqua1";
        };
        "ui.statusline.inactive" = {
          fg = "fg1";
          bg = "bg1";
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
          fg1 = "#${config.colorScheme.palette.base05}"; # main foreground (base16 standard)
          fg2 = "#${config.colorScheme.palette.base05}";
          fg3 = "#${config.colorScheme.palette.base04}";
          fg4 = "#${config.colorScheme.palette.base03}";
          gray = "#${config.colorScheme.palette.base03}"; # comments/secondary text
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
