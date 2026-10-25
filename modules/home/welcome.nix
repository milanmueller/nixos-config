# Welcome banner for interactive shells (SSH login and new terminals):
# hostname in ASCII art plus a loud warning if ~/nixos-config is dirty or out of sync.
{ pkgs, userConfig, ... }:
let
  welcome = pkgs.writeShellApplication {
    name = "welcome";
    runtimeInputs = with pkgs; [
      figlet
      git
      openssh
      coreutils
      hostname
    ];
    text = ''
      repo="${userConfig.homeDir}/nixos-config"
      red=$'\e[1;97;41m'
      cyan=$'\e[36m'
      reset=$'\e[0m'

      printf '%s%s%s\n' "$cyan" "$(figlet -t -f standard "$(hostname)")" "$reset"

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
