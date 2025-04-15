{
  lib,
  config,
  pkgs,
  cosmic-themes-base16,
  ...
}:
let
  base16Colors = with config.colorScheme.palette; [
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
  ];
  generatedThemes =
    pkgs.runCommand "cosmic-themes"
      {
        buildInputs = [ cosmic-themes-base16 ];
      }
      ''
        mkdir -p $out
        ${cosmic-themes-base16}/bin/cosmic-themes-base16 light ${lib.concatStringsSep " " base16Colors}
        mv * $out 2>/dev/null || true
      '';
in
{
  # Configurable options
  options.cosmicTerm = {
    enable = lib.mkEnableOption "Cosmic Term font size configuration";
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for cosmic term.";
      example = 14;
    };
    targetDir = lib.mkOption {
      type = lib.types.str;
      default = ".config/test";
      description = "I don't need a description";
    };
  };

  # Implementation of option application
  config = lib.mkIf config.cosmicTerm.enable {
    # Write configuration to files
    # home.file = {
    #   ".config/cosmic/com.system76.CosmicTerm/v1/font_size" = {
    #     text = toString config.cosmicTerm.fontSize;
    #   };

    # };

    # Dynamically install all gneerated theme files
    home.file =
      let
        files = builtins.attrNames (builtins.readDir generatedThemes);
      in
      lib.listToAttrs (
        map (file: {
          name = "${config.cosmicTerm.targetDir}/${file}";
          value = {
            source = "${generatedThemes}/${file}";
          };
        }) files
      );
  };
}
