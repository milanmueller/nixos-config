# Welcome banner for interactive shells (SSH login and new terminals):
# hostname in ASCII art, a quote of the day (see welcome/quotes.nix) and a loud
# warning if ~/nixos-config is dirty or out of sync.
{
  lib,
  pkgs,
  userConfig,
  ...
}:
let
  # One "quote<TAB>author" per line.
  quotesFile = pkgs.writeText "welcome-quotes.tsv" (
    lib.concatStrings (
      lib.mapAttrsToList (
        author: quotes: lib.concatMapStrings (q: "${q}\t${author}\n") quotes
      ) (import ./welcome/quotes.nix)
    )
  );

  welcome = pkgs.writeShellApplication {
    name = "welcome";
    runtimeInputs = with pkgs; [
      figlet
      git
      openssh
      coreutils
      hostname
      ncurses
    ];
    text = ''
      repo="${userConfig.homeDir}/nixos-config"
      red=$'\e[1;97;41m'
      cyan=$'\e[36m'
      reset=$'\e[0m'

      dim=$'\e[2;3m'
      printf '%s%s%s\n' "$cyan" "$(figlet -t -f standard "$(hostname)")" "$reset"

      # Quote of the day: same quote all day, picked by a hash of the date.
      mapfile -t quotes < ${quotesFile}
      if [ "''${#quotes[@]}" -gt 0 ]; then
        seed=$(date +%F | cksum | cut -d' ' -f1)
        IFS=$'\t' read -r quote author <<<"''${quotes[seed % ''${#quotes[@]}]}"
        cols=$(tput cols 2>/dev/null || echo 80)
        printf '%s' "$dim"
        printf '„%s“\n' "$quote" | fold -s -w $((cols > 80 ? 78 : cols - 2))
        printf '    — %s%s\n\n' "$author" "$reset"
      fi

      [ -d "$repo/.git" ] || exit 0

      # Refresh remote state at most every 10 minutes; stay quiet when offline.
      fetch_head="$repo/.git/FETCH_HEAD"
      if [ -z "$(find "$fetch_head" -mmin -10 2>/dev/null)" ]; then
        GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=3" \
          timeout 5 git -C "$repo" fetch --quiet 2>/dev/null || true
      fi

      problems=()
      if [ -n "$(git -C "$repo" status --porcelain 2>/dev/null)" ]; then
        problems+=("UNCOMMITTED CHANGES in $repo")
      fi
      if upstream=$(git -C "$repo" rev-parse --abbrev-ref '@{u}' 2>/dev/null); then
        read -r ahead behind < <(git -C "$repo" rev-list --left-right --count "HEAD...$upstream")
        [ "$behind" -gt 0 ] && problems+=("$behind UN-PULLED commit(s) on $upstream - run git pull")
        [ "$ahead" -gt 0 ] && problems+=("$ahead UNPUSHED commit(s) in $repo")
      fi

      if [ "''${#problems[@]}" -gt 0 ]; then
        width=64
        bar=$(printf '%*s' "$width" "")
        printf '%s%s%s\n' "$red" "$bar" "$reset"
        printf '%s  %-*s%s\n' "$red" $((width - 2)) "!!! WARNING: nixos-config out of sync !!!" "$reset"
        for p in "''${problems[@]}"; do
          printf '%s  %-*s%s\n' "$red" $((width - 2)) "- $p" "$reset"
        done
        printf '%s%s%s\n\n' "$red" "$bar" "$reset"
      fi
    '';
  };
in
{
  home.packages = [ welcome ];

  programs.zsh.initContent = ''
    # Show welcome banner once per top-level interactive shell
    if [[ -o interactive && -t 1 && -z "$WELCOME_SHOWN" ]]; then
      export WELCOME_SHOWN=1
      welcome
    fi
  '';
}
