{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDir;
}
