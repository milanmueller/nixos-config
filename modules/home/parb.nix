# `parb` (pull and rebuild): cd ~/nixos-config, git pull, sudo nixos-rebuild
# switch, with a spinning ASCII NixOS snowflake, a dancing Tux and a 5-line log tail.
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
      text = "SNOW_FILE=${./parb/frames.txt}\nTUX_FILE=${./parb/tux.txt}\n" + builtins.readFile ./parb/parb.sh;
    })
  ];
}
