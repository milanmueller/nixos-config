{ lib, pkgs, ... }:
{
  languages = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.nixfmt;
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
      roots = [
        "pyproject.toml"
        ".git"
      ];
    }
    {
      name = "typst";
      auto-format = true;
      formatter.command = "typstyle";
      language-servers = [
        "tinymist"
        "codebook"
      ];
    }
    {
      name = "latex";
      auto-format = true;
      formatter = {
        command = "tex-fmt";
        args = [ "--stdin" ];
      };
      language-servers = [
        "texlab"
        "codebook"
      ];
    }
    {
      name = "markdown";
      language-servers = [ "codebook" ];
    }
  ];
  language-server = {
    codebook = {
      command = "codebook-lsp";
      args = [ "serve" ];
    };
    haskell-language-server = {
      config = {
        formattingProvider = "fourmolu";
      };
    };
  };
}
