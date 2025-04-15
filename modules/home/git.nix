{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Milan Müller";
    userEmail = "development@milanmueller.de";
  };
}
