{
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;

  # Convert 6-char hex to r/g/b format for OSC terminal escape sequences
  toRGB =
    hex:
    "${builtins.substring 0 2 hex}/${builtins.substring 2 2 hex}/${builtins.substring 4 2 hex}";
in
{
  programs.zsh = {
    enable = true;

    # Enable completion with caching for faster startup
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit -C";

    # Enable autosuggestions (like nushell's preview feature)
    autosuggestion.enable = true;

    # Enable syntax highlighting with base16 colors
    syntaxHighlighting.enable = true;

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "git"
    #     "docker-compose"
    #     "docker"
    #     "podman"
    #   ];
    #   theme = ""; # Disable Oh-My-Zsh theme, use Starship instead
    # };

    # Set base16 colors for various zsh components
    initContent = ''
      # Apply base16 color scheme to terminal via OSC escape sequences
      if [[ -t 1 && "$TERM" != "dumb" ]]; then
        printf '\033]4;0;rgb:${toRGB palette.base00}\033\\'
        printf '\033]4;1;rgb:${toRGB palette.base08}\033\\'
        printf '\033]4;2;rgb:${toRGB palette.base0B}\033\\'
        printf '\033]4;3;rgb:${toRGB palette.base0A}\033\\'
        printf '\033]4;4;rgb:${toRGB palette.base0D}\033\\'
        printf '\033]4;5;rgb:${toRGB palette.base0E}\033\\'
        printf '\033]4;6;rgb:${toRGB palette.base0C}\033\\'
        printf '\033]4;7;rgb:${toRGB palette.base05}\033\\'
        printf '\033]4;8;rgb:${toRGB palette.base03}\033\\'
        printf '\033]4;9;rgb:${toRGB palette.base08}\033\\'
        printf '\033]4;10;rgb:${toRGB palette.base0B}\033\\'
        printf '\033]4;11;rgb:${toRGB palette.base0A}\033\\'
        printf '\033]4;12;rgb:${toRGB palette.base0D}\033\\'
        printf '\033]4;13;rgb:${toRGB palette.base0E}\033\\'
        printf '\033]4;14;rgb:${toRGB palette.base0C}\033\\'
        printf '\033]4;15;rgb:${toRGB palette.base07}\033\\'
        printf '\033]4;16;rgb:${toRGB palette.base09}\033\\'
        printf '\033]4;17;rgb:${toRGB palette.base0F}\033\\'
        printf '\033]4;18;rgb:${toRGB palette.base01}\033\\'
        printf '\033]4;19;rgb:${toRGB palette.base02}\033\\'
        printf '\033]4;20;rgb:${toRGB palette.base04}\033\\'
        printf '\033]4;21;rgb:${toRGB palette.base06}\033\\'
        printf '\033]10;rgb:${toRGB palette.base05}\033\\'
        printf '\033]11;rgb:${toRGB palette.base00}\033\\'
        printf '\033]12;rgb:${toRGB palette.base05}\033\\'
      fi

      # # Syntax highlighting colors (zsh-syntax-highlighting)
      # typeset -uA ZSH_HIGHLIGHT_STYLES
      # ZSH_HIGHLIGHT_STYLES[default]='fg=#${palette.base0A}'
      # ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#${palette.base0A}'
      # ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#${palette.base0E}'
      # ZSH_HIGHLIGHT_STYLES[alias]='fg=#${palette.base0B}'
      # ZSH_HIGHLIGHT_STYLES[builtin]='fg=#${palette.base0A}'
      # ZSH_HIGHLIGHT_STYLES[function]='fg=#${palette.base0B}'
      # ZSH_HIGHLIGHT_STYLES[command]='fg=#${palette.base0D}'
      # ZSH_HIGHLIGHT_STYLES[precommand]='fg=#${palette.base0C}'
      # ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#${palette.base0E}'
      # ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#${palette.base0B}'
      # ZSH_HIGHLIGHT_STYLES[path]='fg=#${palette.base0C},underline'
      # ZSH_HIGHLIGHT_STYLES[globbing]='fg=#${palette.base0E}'
      # ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#${palette.base0D}'
      # ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#${palette.base09}'
      # ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#${palette.base09}'
      # ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#${palette.base0E}'
      # ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#${palette.base0A}'
      # ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#${palette.base0A}'
      # ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#${palette.base0C}'
      # ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#${palette.base0C}'
      # ZSH_HIGHLIGHT_STYLES[assign]='fg=#${palette.base05}'

      # # Autosuggestion color
      # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#${palette.base03}'

      # # LS_COLORS for file listings
      # LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
    '';
  };

  # Starship prompt with base16 colors
  programs.starship = {
    enable = true;
    settings = {
      # Format configuration
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$direnv$fill$time\n$character";

      # Character (prompt symbol)
      character = {
        success_symbol = "[>>=](bold #${palette.base0B})";
        error_symbol = "[>>=](bold #${palette.base08})";
      };

      # Username
      username = {
        style_user = "bold #${palette.base0D}";
        style_root = "bold #${palette.base08}";
        format = "[$user]($style)";
        show_always = true;
      };

      # Hostname
      hostname = {
        ssh_only = false;
        format = "[@$hostname](bold #${palette.base0D}) ";
        disabled = false;
      };

      # Directory
      directory = {
        style = "bold #${palette.base0B}";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      # Git branch
      git_branch = {
        symbol = "⸙";
        style = "bold #${palette.base0E}";
        format = "[$symbol$branch]($style) ";
      };

      # Git status
      git_status = {
        style = "bold #${palette.base0A}";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      # Nix shell indicator
      nix_shell = {
        symbol = "❄";
        style = "bold #${palette.base0C}";
        format = "[$symbol$state]($style) ";
      };

      # Direnv status
      direnv = {
        symbol = "▶";
        style = "bold #${palette.base0A}";
        format = "[$symbol$loaded/$allowed]($style) ";
        disabled = false;
      };

      # Fill module (creates space between left and right elements)
      fill = {
        symbol = "─";
        style = "#${palette.base03}";
      };

      # Time (right-aligned)
      time = {
        disabled = false;
        style = "bold #${palette.base0D}";
        format = "[$time]($style)";
        time_format = "%Y-%m-%d %H:%M:%S";
      };
    };
  };
}
