{ config, pkgs, ... }:
{
  # programs.git.settings.user.name
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Milan Müller";
        email = "development@milanmueller.de";
      };
      core.pager = "delta";

      # interactive.diffFilter = "'delta --color-only'";
      delta = {
        light = true;
        navigate = true;
      };
    };
  };
}
