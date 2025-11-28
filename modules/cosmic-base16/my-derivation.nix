let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
  name = "my-derivation";
  src = null;
  dontUnpack = true;
  buildPhase = ''
    mkdir -p $out
    echo "test" > $out/file
  '';
}
