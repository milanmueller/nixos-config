# Load a tinted-theming scheme by slug, preferring base24 and falling back to
# base16 (with base10-17 derived from the base16 colors).
#
# base24 = base16 + base10/11 (darker backgrounds) + base12-17 (bright
# red, yellow, green, cyan, blue, magenta). The result always has all 24 keys
# and is shaped like a nix-colors scheme ({ slug, name, author, variant, palette }).
{ lib, tinted-schemes }:
slug:
let
  base24File = "${tinted-schemes}/base24/${slug}.yaml";
  base16File = "${tinted-schemes}/base16/${slug}.yaml";
  isBase24 = builtins.pathExists base24File;
  file =
    if isBase24 then
      base24File
    else if builtins.pathExists base16File then
      base16File
    else
      throw "Color scheme '${slug}' not found in tinted-theming/schemes (base24 or base16)";

  lines = lib.splitString "\n" (builtins.readFile file);

  # Matches `  base0A: "#aabbcc"` (optionally unquoted / with trailing comment)
  parsePalette =
    acc: line:
    let
      m = builtins.match ''[[:space:]]*(base[0-9A-F]{2}):[[:space:]]*"?#?([0-9a-fA-F]{6})"?.*'' line;
    in
    if m == null then acc else acc // { ${builtins.elemAt m 0} = lib.toLower (builtins.elemAt m 1); };

  parsed = builtins.foldl' parsePalette { } lines;

  field =
    key:
    let
      m = lib.findFirst (m: m != null) null (
        map (l: builtins.match ''${key}:[[:space:]]*"?([^"]*)"?[[:space:]]*'' l) lines
      );
    in
    if m == null then "" else builtins.elemAt m 0;

  # Derived values when only base16 is available
  fallback = {
    base10 = parsed.base00;
    base11 = parsed.base00;
    base12 = parsed.base08;
    base13 = parsed.base0A;
    base14 = parsed.base0B;
    base15 = parsed.base0C;
    base16 = parsed.base0D;
    base17 = parsed.base0E;
  };
in
{
  inherit slug;
  name = field "name";
  author = field "author";
  variant = field "variant";
  palette = fallback // parsed;
}
