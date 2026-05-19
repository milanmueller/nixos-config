{ config, ... }:
let
  palette = config.colorScheme.palette;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "None";

      font = {
        normal.family = "JetBrainsMono Nerd Font Mono";
        bold.family = "JetBrainsMono Nerd Font Mono";
        italic.family = "JetBrainsMono Nerd Font Mono";
        bold_italic.family = "JetBrainsMono Nerd Font Mono";
      };

      colors = {
        primary = {
          background = "#${palette.base00}";
          foreground = "#${palette.base05}";
        };

        cursor = {
          text = "#${palette.base00}";
          cursor = "#${palette.base05}";
        };

        selection = {
          text = "#${palette.base05}";
          background = "#${palette.base02}";
        };

        normal = {
          black = "#${palette.base00}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base05}";
        };

        bright = {
          black = "#${palette.base03}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base07}";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#${palette.base09}";
          }
          {
            index = 17;
            color = "#${palette.base0F}";
          }
        ];
      };
    };
  };
}
