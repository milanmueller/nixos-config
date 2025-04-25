{ lib, pkgs, ... }:
{
  languages = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      language-servers = [ "nil" ];
    }
    {
      name = "rust";
      auto-format = true;
      language-servers = [ "rust-analyzer" ];
    }
    {
      name = "haskell";
      auto-format = true;
      language-servers = [
        "haskell-language-server"
      ];
    }
    {
      name = "python";
      language-servers = [
        "pyright"
        "ruff"
      ];
      formatter = {
        command = "ruff";
        args = [
          "format"
          "-"
        ];
        auto-format = true;
      };
    }
  ];
}
