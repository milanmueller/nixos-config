{ userConfig, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      working-directory = userConfig.homeDir;
      desktop-notifications = false;
      keybind = [
        "alt+h=goto_split:left"
        "alt+j=goto_split:down"
        "alt+k=goto_split:up"
        "alt+l=goto_split:right"
      ];
    };
  };
}
