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
        "pylsp"
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
  language-server = {
    pylsp.config.pylsp.plugins.pylsp_mypy = {
      enabled = true;
      live_mode = true;
      strict = true;
    };
  };
}
