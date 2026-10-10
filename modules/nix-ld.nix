{ pkgs, ... }:
{
  # Run generic-Linux dynamically linked binaries (the ones Zed downloads for
  # language servers, e.g. package-version-server or rust-analyzer, and similar
  # prebuilt tooling). Without this, /lib64/ld-linux-x86-64.so.2 is NixOS'
  # stub-ld, which only prints the "cannot run dynamically linked executables"
  # message. See https://nix.dev/permalink/stub-ld
  programs.nix-ld = {
    enable = true;

    # Extra shared libraries such binaries commonly expect beyond glibc.
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib
      openssl
      curl
      libxml2
    ];
  };
}
