{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        edit_mode: "vi",
        show_banner: false,
      } 
      $env.PATH = ($env.PATH | 
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
      )
      $env.PROMPT_COMMAND = {
        # Check if we're in a container
        let is_docker = ("/.dockerenv" | path exists)
        let is_podman = ("/run/.containerenv" | path exists)
        let container_indicator = if $is_docker { 
            $"(ansi red)(ansi reset) "  # Docker/Podman symbol () in red
        } else if $is_podman {
            $"(ansi red)(ansi reset) "  # Docker/Podman symbol () in red
        } else { 
            "" 
        }

        # Get the current directory (shortened)
        let dir = ($env.PWD | str replace $env.HOME "~")

        # Username and hostname
        let user = (whoami)
        let host = (hostname)

        # Fancy prompt with colors and symbols
        if $is_docker or $is_podman {
          $"($container_indicator)(ansi green)($user)@(ansi red)($host)(ansi reset): (ansi blue)($dir)(ansi reset) (ansi purple)❯(ansi reset) "
        } else {
          $"($container_indicator)(ansi green)($user)@(ansi yellow)($host)(ansi reset): (ansi blue)($dir)(ansi reset) (ansi purple)❯(ansi reset) "
        }
      }

      # Optional: Set the right-side prompt (e.g., for git branch or time)
      $env.PROMPT_COMMAND_RIGHT = {
          let time = (date now | format date "%H:%M")
          $"(ansi cyan)($time)(ansi reset)"
      }
    '';
  };
}
