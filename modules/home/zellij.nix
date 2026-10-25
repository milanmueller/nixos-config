{ config, ... }:
let
  inherit (config.colorScheme) palette;
  hex = c: "#${c}";
in
{
  programs.zellij = {
    enable = true;
    settings.theme = "base16-custom";
    # Theme files need the `themes { <name> { ... } }` wrapper, so the KDL is
    # written out as a string rather than an attrset.
    themes.base16-custom = ''
      themes {
        base16-custom {
          fg "${hex palette.base05}"
          bg "${hex palette.base00}"
          black "${hex palette.base01}"
          red "${hex palette.base08}"
          green "${hex palette.base0B}"
          yellow "${hex palette.base0A}"
          blue "${hex palette.base0D}"
          magenta "${hex palette.base0E}"
          cyan "${hex palette.base0C}"
          white "${hex palette.base06}"
          orange "${hex palette.base09}"
        }
      }
    '';
  };
}
