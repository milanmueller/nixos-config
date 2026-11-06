# `parb` (pull and rebuild): cd ~/nixos-config, git pull, sudo nixos-rebuild
# switch, with a Tux-hammering-the-NixOS-logo animation and a 3-line log tail.
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "parb";
      runtimeInputs = with pkgs; [
        git
        coreutils
        gnused
        ncurses
      ];
      text = builtins.readFile ./parb/parb.sh;
    })
  ];
}
